#/usr/bin/env bash

KIBANA_TARGET_SERVER=localhost
LOGSTASH_TARGET_SERVER=localhost
ES_TARGET_SERVER=localhost

cat <<EOF
Change 'ELASTICSEARCH_HOST_PORT' variable appropriately in env.sh
It is the list of the hostnames that will be run Elasticsearch.
Default value is '["localhost:5921"]'.
You can use default value if you are going to run Elasticsearch and Logastash on the same server.

[Press Enter to edit 'env.sh']
EOF
read

vi env.sh # ELASTICSEARCH_HOST_PORT='["localhost:5921"]' change the value approppriately

## install es
./install elasticsearch -s $ES_TARGET_SERVER -m 4g # this is a heap size for es.

## install kibana
./install kibana -s $KIBANA_TARGET_SERVER -e $ES_TARGET_SERVER

# install logstash - hadoop - ganglia
./install logstash -s $LOGSTASH_TARGET_SERVER -c hadoop -p ganglia -g development

# install logstash - hadoop - jmx
cat > hadoop-deploy.config<<EOF
namenode host001
namenode host002
journalnode host001
journalnode host002
journalnode host003
datanode host004
datanode host005
datanode host006
EOF
./install logstash -s $LOGSTASH_TARGET_SERVER -c hadoop -p jmx -f ./hadoop-deploy.config -k -g development


## install logstash - hadoop-poller - jmx, ganglia
cat > namenodes.config<<EOF
host001:50070
host002:50070
EOF

./install logstash -s $LOGSTASH_TARGET_SERVER -c hadoop-poller -p ganglia -f ./namenodes.config -k -g development
./install logstash -s $LOGSTASH_TARGET_SERVER -c hadoop-poller -p jmx -f ./namenodes.config -k -g development

## install logstash - tajo - ganglia
./install logstash -s $LOGSTASH_TARGET_SERVER -c tajo -p ganglia -k -g development

## install logstash - flume - ganglia
./install logstash -s $LOGSTASH_TARGET_SERVER -c flume -p ganglia -k -g development

## install logstash - flume - jmx
cat > flume-deploy.config<<EOF
flume host001
flume host002
flume host003
flume host004
EOF
./install logstash -s $LOGSTASH_TARGET_SERVER -c flume -p jmx -k -f ./flume-deploy.config -g development

## install logstash - hbase - ganglia
./install logstash -s $LOGSTASH_TARGET_SERVER -c hbase -p ganglia -k -g development

## install logstash - hbase - jmx
cat > hbase-deploy.config<<EOF
hbase-master host001
hbase-master host002
hbase-regionserver host003
hbase-regionserver host004
hbase-regionserver host005
EOF
./install logstash -s $LOGSTASH_TARGET_SERVER -c hbase -p jmx -k -f ./hbase-deploy.config -g development

## install logstash - zookeeper - jmx
cat > zookeeper-deploy.config<<EOF
zookeeper host001
zookeeper host002
zookeeper host003
EOF
./install logstash -s $LOGSTASH_TARGET_SERVER -c zookeeper -p jmx -k -f ./zookeeper-deploy.config -g development

## install logstash - elasticsearch - http
cat > elasticsearch-server.config<<EOF
host001:9200
EOF
### Elasticsearch metrics are collected via a node. You should specify one server name. 
./install logstash -s $LOGSTASH_TARGET_SERVER -c elasticsearch -p http -k -f ./elasticsearch-server.config -g development

## install logstash - system metric - http
./install logstash -s $LOGSTASH_TARGET_SERVER -c system -p http -k -g development

# install system metric collector agent
cat > sysagent-deploy.config<<EOF
host001
host002
host003
host004
host005
EOF

./install sysagent -s ./sysagent-deploy.config

## install logstash - alert 
./install alert -s $LOGSTASH_TARGET_SERVER -e $ES_TARGET_SERVER

# configure es and start
./remote-es config -s $ES_TARGET_SERVER
./remote-es start -s $ES_TARGET_SERVER

# kibana data restore
cd ./kibana-data
./restore.sh $ES_TARGET_SERVER:5911 hadoop-ganglia.json development
./restore.sh $ES_TARGET_SERVER:5911 hadoop-jmx.json development
./restore.sh $ES_TARGET_SERVER:5911 tajo-ganglia.json development
./restore.sh $ES_TARGET_SERVER:5911 hbase-ganglia.json development
./restore.sh $ES_TARGET_SERVER:5911 hbase-jmx.json development
./restore.sh $ES_TARGET_SERVER:5911 flume-ganglia.json development
./restore.sh $ES_TARGET_SERVER:5911 flume-jmx.json development
./restore.sh $ES_TARGET_SERVER:5911 zookeeper-jmx.json development
./restore.sh $ES_TARGET_SERVER:5911 system-http.json development
./restore.sh $ES_TARGET_SERVER:5911 elasticsearch-http.json development

