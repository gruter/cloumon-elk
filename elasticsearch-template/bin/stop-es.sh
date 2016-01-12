#!/bin/bash

ES_HOME=`cd $(dirname "$0")/..; pwd`
ES_PID=`cat $ES_HOME/bin/es.pid`

# echo $ES_PID
kill -9 $ES_PID
echo "elasticsearch is stopped."
