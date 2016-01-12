#!/bin/bash

KIBANA_HOME=`cd $(dirname "$0")/..; pwd`
KIBANA_PID=`cat $KIBANA_HOME/kibana.pid`

if [ -z $KIBANA_PID ]; then
    KIBANA_PID_COUNT=0	
else
    KIBANA_PID_COUNT=`ps -ef | grep $KIBANA_PID | grep -v grep | wc -l`
fi

if [ $KIBANA_PID_COUNT -gt 0 ]; then
    echo "kibana is running already"
    exit
fi

$KIBANA_HOME/bin/kibana -q &
KIBANA_PID=$!
echo $KIBANA_PID > $KIBANA_HOME/kibana.pid

echo "kibana is started"
