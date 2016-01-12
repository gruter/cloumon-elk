#!/bin/bash
LOGSTASH_HOME=`cd $(dirname "$0")/..; pwd`

LOGSTASH=$LOGSTASH_HOME/bin/logstash
CLUSTER_OPTION="default"

print_logstash_help() {
    cat <<EOF
Usage: $0 [options]

This script helps to start cloumon-logstash

Options:
  -g TEXT                 Cluster name. ex) default,test-cluster
  -c TEXT                 Component name. ex) {tajo,hadoop,zookeeper}
  -p TEXT                 Protocol name. ex) {ganglia,jmx}
  -h                      Show this message.
EOF
}

require_option () {
  if [[ ! $1 ]]; then
    echo "$2 is required."
  fi
}

parse_args() {
  help_page=$1
  shift
  # quoting
  QUOTED_OPTS=
  for o in $@; do
    QUOTED_OPTS="$QUOTED_OPTS \"$o\""
  done

  eval set -- "$QUOTED_OPTS" 

  while true; do
    #echo $1
    case "$1" in
      ("-c")
        COMPONENT_OPTION=$2
        shift 2
      ;;
      ("-p")
        PROTOCOL_OPTION=$2
        shift 2
      ;;
      ("-g")
        CLUSTER_OPTION=$2
        shift 2
      ;;
      ("-h"|"--help")
        eval $help_page
        exit 0
        shift
      ;;
      ("--") shift; break ;;
      #(*) break;;
    esac
  done
  REMAINDER_ARGS="$@"
}

