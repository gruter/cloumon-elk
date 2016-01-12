#!/bin/bash

ES_HOME=`cd $(dirname "$0")/..; pwd`

if [ -e $ES_HOME/bin/es.pid ]; then
  ES_PID=`cat $ES_HOME/bin/es.pid`
fi

export ES_HEAP_SIZE=

if [ -z $ES_PID ]; then
    ES_PID_COUNT=0	
else
    ES_PID_COUNT=`ps -ef | grep $ES_PID | grep -v grep | wc -l`
fi

if [ $ES_PID_COUNT -gt 0 ]; then
    echo "elasticsearch is running already"
    exit
fi

$ES_HOME/bin/elasticsearch -d -p $ES_HOME/bin/es.pid
echo "elasticsearch is running now."
