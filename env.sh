#!/usr/bin/env bash
INSTALL_HOME=$(cd `dirname "$0"`; pwd)

# Storage option 
ELASTICSEARCH_HOST_PORT='["localhost:5921"]'

# common
LOGSTASH_PACKAGE_FILE=cloumon-logstash.tar.gz
KIBANA_PACKAGE_FILE=cloumon-kibana.tar.gz
ELASTICSEARCH_PACKAGE_FILE=cloumon-elasticsearch.tar.gz
ALERT_PACKAGE_FILE=cloumon-alert.tar.gz
SYSAGENT_PACKAGE_FILE=gruter-system-metrics-agent-0.0.1.r6.tar

SYSAGENT_DIRECTORY_NAME=gruter-system-metrics-agent

TOOLS_BIN=$INSTALL_HOME/tools.sh

ELASTICSEARCH_VERSION=2.1.1
LOGSTASH_VERSION=2.1.1
KIBANA_VERSION=4.3.1-linux-x64

ELASTICSEARCH_FULL_NAME=elasticsearch-$ELASTICSEARCH_VERSION
LOGSTASH_FULL_NAME=logstash-$LOGSTASH_VERSION
KIBANA_FULL_NAME=kibana-$KIBANA_VERSION

ELASTICSEARCH_BINARY_DIR=$INSTALL_HOME/$ELASTICSEARCH_FULL_NAME
ELASTICSEARCH_TEMPLATE=$INSTALL_HOME/elasticsearch-template

LOGSTASH_BINARY_DIR=$INSTALL_HOME/$LOGSTASH_FULL_NAME
LOGSTASH_TEMPLATE=$INSTALL_HOME/logstash-template

KIBANA_BINARY_DIR=$INSTALL_HOME/$KIBANA_FULL_NAME
KIBANA_TEMPLATE=$INSTALL_HOME/kibana-template

ELASTICSEARCH_DOWNLOAD_URL="https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${ELASTICSEARCH_VERSION}/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz"
LOGSTASH_DOWNLOAD_URL="https://download.elastic.co/logstash/logstash/logstash-${LOGSTASH_VERSION}.tar.gz"
KIBANA_DOWNLOAD_URL="https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}.tar.gz"

## escaping
# ELASTICSEARCH_HOST_PORT=`echo $ELASTICSEARCH_HOST_PORT | sed -e 's/"/\\\\\\\\\\\\"/g'` # this only needs to run sed at remote host
