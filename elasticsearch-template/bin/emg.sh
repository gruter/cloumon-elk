#!/usr/bin/env bash

ES_HOST="localhost"
ES_PORT=5911

help() {
cat <<EOF
Usage: $0 <command> <options>

commands and options:
  close <n days>			close indices older than <n> days
  delete <n days>			delete indices older than <n> days
  backup <YYYY.mm.dd>			backup indices which ends with the date pattern 
  delete-backup <n days>                delete backups older than <n> days
EOF
}

EXISTS_CURATOR=`which curator`
if [ -z $EXISTS_CURATOR ] || [[ $EXISTS_CURATOR == *"no curator"* ]]; then
  echo "Please install elasticsearch-curator before use $0"
  echo "You can install that using 'sudo pip install elasticsearch-curator'"
  exit 1
fi


SYSTEM_NAME=`uname -s`
COMMAND=$1
FIRST_OPTION=$2

if [ $# -lt 2 ]; then
  help
  exit 1
fi

METRIC_REPOSITORY_NAME="cloumon-elk-metric-backup"
META_REPOSITORY_NAME="cloumon-elk-meta-backup"

case $COMMAND in
  ("close") curator --host $ES_HOST --port $ES_PORT close indices --time-unit days --older-than $FIRST_OPTION --timestring %Y.%m.%d ;;
  ("delete") curator --host $ES_HOST --port $ES_PORT delete indices --time-unit days --older-than $FIRST_OPTION --timestring %Y.%m.%d ;;
  ("backup")
    es_repo_mgr create fs --repository "$METRIC_REPOSITORY_NAME" --location "$METRIC_REPOSITORY_NAME"
    es_repo_mgr create fs --repository "$META_REPOSITORY_NAME" --location "$META_REPOSITORY_NAME"
    RETRY_COUNT=0
    SNAPSHOT_NAME="metric-backup-$FIRST_OPTION"
    while [ true ]; do
      curator snapshot --repository "$METRIC_REPOSITORY_NAME"  --name $SNAPSHOT_NAME indices --suffix "$FIRST_OPTION" 
      BACKUP_RTN=$?
      if [ $BACKUP_RTN -eq 0 ]; then
        break
      fi
      RETRY_COUNT=$(($RETRY_COUNT + 1))
      SNAPSHOT_NAME="metric-backup-$RETRY_COUNT-$FIRST_OPTION"
    done
    curator snapshot --repository "$META_REPOSITORY_NAME" --prefix "meta-backup-" indices --index ".kibana" --index ".threshold-filter"
    ;;
  ("delete-backup")
    curator delete snapshots --repository $METRIC_REPOSITORY_NAME --older-than $FIRST_OPTION --time-unit days --timestring %Y.%m.%d
    ;;
  (*) echo "not supported command: $COMMAND"
      help  ;;
esac

