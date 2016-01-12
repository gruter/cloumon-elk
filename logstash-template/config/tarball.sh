#!/bin/bash

TAR_HOME=$(cd `dirname "$0"`; pwd)

pushd .
cd "$TAR_HOME"

HADOOP_TEMPLATE_FILENAME=logstash-hadoop-template.tar.gz
TAJO_TEMPLATE_FILENAME=logstash-tajo-template.tar.gz
FLUME_TEMPLATE_FILENAME=logstash-flume-template.tar.gz
HBASE_TEMPLATE_FILENAME=logstash-hbase-template.tar.gz
SYSTEM_TEMPLATE_FILENAME=logstash-system-template.tar.gz
ZOOKEEPER_TEMPLATE_FILENAME=logstash-zookeeper-template.tar.gz
ELASTICSEARCH_TEMPLATE_FILENAME=logstash-elasticsearch-template.tar.gz




compress() {
  if [ $# -lt 3 ]; then
    echo "needs more args" 
  else
    local TAR_CMD="tar czf"
    local TYPE=$1
    local TEMPLATE_FILENAME=$2
    shift 2
    if [ -e $TEMPLATE_FILENAME ]; then
      echo "Delete existing template file: $TEMPLATE_FILENAME"
      rm $TEMPLATE_FILENAME
    fi

    echo "Compressing $TYPE templates"
    $TAR_CMD $TEMPLATE_FILENAME $@
  fi
}


compress "hadoop" $HADOOP_TEMPLATE_FILENAME hadoop-* jmxconf/hadoop
compress "tajo" $TAJO_TEMPLATE_FILENAME tajo-* jmxconf/tajo
compress "flume" $FLUME_TEMPLATE_FILENAME flume-* jmxconf/flume
compress "hbase" $HBASE_TEMPLATE_FILENAME hbase-* jmxconf/hbase
compress "system" $SYSTEM_TEMPLATE_FILENAME system-*
compress "zookeeper" $ZOOKEEPER_TEMPLATE_FILENAME zookeeper-* jmxconf/zookeeper
compress "elasticsearch" $ELASTICSEARCH_TEMPLATE_FILENAME elasticsearch-*

echo "Success to compress templates"

mv $HADOOP_TEMPLATE_FILENAME $TAJO_TEMPLATE_FILENAME $FLUME_TEMPLATE_FILENAME $HBASE_TEMPLATE_FILENAME $SYSTEM_TEMPLATE_FILENAME $ZOOKEEPER_TEMPLATE_FILENAME $ELASTICSEARCH_TEMPLATE_FILENAME "$TAR_HOME/../../"
echo "Success to moving home directory"

popd
