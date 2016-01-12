#!/bin/bash

KIBANA_HOME=`cd $(dirname "$0")/..; pwd`

KIBANA_PID=`cat $KIBANA_HOME/kibana.pid`
KIBANA_PID_COUNT=`ps -ef  | grep $KIBANA_PID | grep -v grep | wc -l`

if [ $KIBANA_PID_COUNT -gt 0 ]; then
    echo "kibana:$KIBANA_PID is killed"
    kill -9 $KIBANA_PID
else
    echo "No running kibana"
fi


