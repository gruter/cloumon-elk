#!/bin/bash
ALERT_HOME=`cd $(dirname "$0"); pwd`

LOGSTASH=$ALERT_HOME/../elk/logstash/bin/logstash

if [ ! -e $LOGSTASH ]; then
  echo "Install logstash first"
  exit
fi

print_help() {
  cat <<EOF
Usage: $0 [options]

Options:
  -c TEXT                 Component name.
  -h                      Show this message.
EOF
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

require_option () {
  if [[ ! $1 ]]; then
    echo "$2 is required."
  fi
}

OPTS=`getopt c:h "$@"`
RT=$?

if [ $RT -ne 0 ] || [ $# -eq 0 ]; then
  echo ""
  print_help
  exit 1
fi  

parse_args "print_help" $OPTS

if [[ ! $COMPONENT_OPTION ]]; then
  require_option "$COMPONENT_OPTION" "component option"
  echo ""
  print_help
  exit 1
fi  


CONFIG_FILENAME=${COMPONENT_OPTION}-alert.config
if [ ! -e $ALERT_HOME/$CONFIG_FILENAME ]; then
  echo "$CONFIG_FILENAME file is not exists in $ALERT_HOME"
  exit 2
fi

ALERT_RUN_LOGFILE=$ALERT_HOME/${COMPONENT_OPTION}-alert.log
ALERT_CONFIG_FILE=$ALERT_HOME/$CONFIG_FILENAME
ALERT_PID_FILE=$ALERT_HOME/${COMPONENT_OPTION}-alert.pid

ALERT_PID=`cat $ALERT_PID_FILE`
if [ -z $ALERT_PID ]; then
    ALERT_PID_COUNT=0	
else
    ALERT_PID_COUNT=`ps -ef | grep $ALERT_PID | grep -v grep | wc -l`
fi

if [ $ALERT_PID_COUNT -gt 0 ]; then
    echo "${COMPONENT_OPTION}-alert is running already"
    exit
fi

#$LOGSTASH --log $ALERT_RUN_LOGFILE -f $ALERT_CONFIG_FILE > $ALERT_RUN_LOGFILE 2>&1 &
$LOGSTASH -f $ALERT_CONFIG_FILE > /dev/null 2>&1 &
RUN_PID=$!
echo $RUN_PID > $ALERT_PID_FILE
echo "${COMPONENT_OPTION} alert is started"
