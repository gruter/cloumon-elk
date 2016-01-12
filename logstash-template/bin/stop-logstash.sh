#!/bin/bash
CURRENT_HOME=`cd $(dirname "$0")/..; pwd`
. $CURRENT_HOME/bin/logstash-env.sh

OPTS=`getopt c:p:hg: "$@"`
RT=$?
if [ $RT -ne 0 ] || [ $# -eq 0 ]; then
  echo ""
  print_logstash_help
  exit 1
fi  

parse_args "print_logstash_help" $OPTS

if [[ ! $COMPONENT_OPTION ]] || [[ ! $PROTOCOL_OPTION ]]; then
  require_option "$COMPONENT_OPTION" "component option"
  require_option "$PROTOCOL_OPTION" "protocol option"
  echo ""
  print_logstash_help
  exit 1
fi  

CONFIG_FILENAME=${CLUSTER_OPTION}-${COMPONENT_OPTION}-${PROTOCOL_OPTION}-to-es.config
if [ ! -e $LOGSTASH_HOME/conf/$CONFIG_FILENAME ]; then
  echo "$CONFIG_FILENAME file is not exists."
  exit 2
fi

LOGSTASH_RUN_LOGFILE=$LOGSTASH_HOME/${CLUSTER_OPTION}-${COMPONENT_OPTION}-${PROTOCOL_OPTION}-logstash.log
LOGSTASH_CLOUMON_CONFIG_FILE=$LOGSTASH_HOME/conf/$CONFIG_FILENAME
LOGSTASH_PID_FILE=$LOGSTASH_HOME/${CLUSTER_OPTION}-${COMPONENT_OPTION}-${PROTOCOL_OPTION}-logstash.pid

LOGSTASH_PID=`cat ${LOGSTASH_PID_FILE} 2> /dev/null`
if [[ ! $LOGSTASH_PID ]]; then
  echo "No running ${CLUSTER_OPTION}-${COMPONENT_OPTION}-${PROTOCOL_OPTION}-logstash"
  exit 0
fi
LOGSTASH_PID_COUNT=`ps -ef  | grep $LOGSTASH_PID | grep -v grep | wc -l`

if [ $LOGSTASH_PID_COUNT -gt 0 ]; then
    echo "${CLUSTER_OPTION}-${COMPONENT_OPTION}-${PROTOCOL_OPTION}-logstash:$LOGSTASH_PID is killed" 
    kill -9 $LOGSTASH_PID
else
    echo "No running ${CLUSTER_OPTION}-${COMPONENT_OPTION}-${PROTOCOL_OPTION}-logstash" 
fi
