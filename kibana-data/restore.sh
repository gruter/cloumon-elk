#!/bin/bash

UTIL_HOME=`dirname "$0"`
UTIL_HOME=`cd $UTIL_HOME; pwd`

JRUBY=$UTIL_HOME/../logstash/vendor/jruby/bin/jruby

if [ $# -lt 2 ]; then
	echo "usage: $0 <host_ip:port> <dumped_filename> <cluster name>"
    exit 1
fi

if [ ! -e $JRUBY ]; then
  pushd .
  cd $UTIL_HOME/..
  tar xzf cloumon-logstash.tar.gz
  popd
fi

$JRUBY $UTIL_HOME/restore.rb $@
