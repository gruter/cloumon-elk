#!/bin/bash

INSTALL_HOME=$(cd `dirname "$0"`; pwd)
. "$INSTALL_HOME"/env.sh

export COPYFILE_DISABLE=1

cd "$INSTALL_HOME"

if [ $# = 1 ]; then
  echo "Delete and compress the tarball"
  case $1 in
  "logstash")
    rm $LOGSTASH_PACKAGE_FILE 2> /dev/null
    tar czf $LOGSTASH_PACKAGE_FILE logstash
    ./logstash-template/config/tarball.sh
    ;;
  "kibana")
    rm $KIBANA_PACKAGE_FILE 2> /dev/null
    tar czf $KIBANA_PACKAGE_FILE kibana
    ;;
  "alert")
    rm $ALERT_PACKAGE_FILE 2> /dev/null
    tar czf $ALERT_PACKAGE_FILE alert
    ;;
  "elasticsearch")
    rm $ELASTICSEARCH_PACKAGE_FILE 2> /dev/null
    tar czf $ELASTICSEARCH_PACKAGE_FILE elasticsearch
    ;;
  *)
    echo "one of these: logstash, kibana, alert, elasticsearch"
    exit 1
    ;;
  esac
elif [ $# = 0 ]; then
  echo "Deleting existing tablls"
  rm $LOGSTASH_PACKAGE_FILE 2> /dev/null
  rm $KIBANA_PACKAGE_FILE 2> /dev/null
  rm $ELASTICSEARCH_PACKAGE_FILE 2> /dev/null
  rm $ALERT_PACKAGE_FILE 2> /dev/null

  echo "Compressing Cloumon ELK"
  tar czf $ELASTICSEARCH_PACKAGE_FILE elasticsearch
  tar czf $LOGSTASH_PACKAGE_FILE logstash
  tar czf $KIBANA_PACKAGE_FILE kibana
  tar czf $ALERT_PACKAGE_FILE alert

  ./logstash-template/config/tarball.sh
fi

