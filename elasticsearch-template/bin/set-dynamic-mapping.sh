#!/bin/bash

if [ $# -lt 1 ]; then
  echo "usage: $0 <server ip:port>"
  exit
fi

HOST_PORT=$1
curl -XPUT "http://$HOST_PORT/_template/system_http_template" -d'
{
    "template": "*-system-http-metrics-*",
    "mappings": {
        "_default_": {
            "dynamic_templates": [
                {
                    "metric_name_field" : { 
                        "match" : "metric_name",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                 },
                {
                    "metric_value_field" : {
                        "match" : "metric_value",
                        "mapping": {
                            "type": "double",
                            "index": "not_analyzed"
                        },
                        "match_mapping_type":"long"
                     }
                 },
        {
                    "hostname_field" : { 
                        "match" : "hostname",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 }
             ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/_template/tajo_ganglia_template" -d'
{
    "template": "*-tajo-ganglia-metrics-*",
    "mappings": {
        "_default_": {
            "dynamic_templates": [
                {
                    "name_field" : { 
                        "match" : "name",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        		{
                    "host_field" : { 
                        "match" : "host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        		{
                    "loghost_field" : { 
                        "match" : "log_host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
                 {
                    "valstr_field" : { 
                        "match" : "val_str",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                },
                {
                    "valdouble_field" : { 
                        "match" : "val_double",
                        "mapping": { 
                            "type": "double", 
                            "index": "not_analyzed"
                        },
                        "match_mapping_type":"string" 
                     }
                }
             ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/_template/tajo_file_index_template" -d'
{
    "template": "*-tajo-file-metrics-*",
    "mappings": {
        "_default_": {
            "dynamic_templates": [
                {
                    "name_field" : { 
                        "match" : "name",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        {
                    "host_field" : { 
                        "match" : "host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
                 {
                    "valstr_field" : { 
                        "match" : "val_str",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                },
                {
                    "valdouble_field" : { 
                        "match" : "val_double",
                        "mapping": { 
                            "type": "double", 
                            "index": "not_analyzed"
                        },
                        "match_mapping_type":"string" 
                     }
                }
             ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/_template/hadoop_ganglia_template" -d'
{
    "template": "*-hadoop-ganglia-metrics-*",
    "mappings": {
        "_default_": {
            "dynamic_templates": [
                {
                    "name_field" : { 
                        "match" : "name",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        		{
                    "host_field" : { 
                        "match" : "host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        		{
                    "loghost_field" : { 
                        "match" : "log_host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
                 {
                    "valstr_field" : { 
                        "match" : "val_str",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                },
                {
                    "valdouble_field" : { 
                        "match" : "val_double",
                        "mapping": { 
                            "type": "double", 
                            "index": "not_analyzed"
                        },
                        "match_mapping_type":"string" 
                     }
                }
             ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/_template/hadoop_jmx_template" -d'
{
    "template": "*-hadoop-jmx-metrics-*",
    "mappings": {
        "_default_": {
            "dynamic_templates": [
                {
                    "name_field" : { 
                        "match" : "name",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                 },
            		{
                    "host_field" : { 
                        "match" : "host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        	{
                    "metric_path_field" : { 
                        "match" : "metric_path",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
                 {
                    "valstr_field" : { 
                        "match" : "val_str",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                },
                {
                    "valdouble_field" : { 
                        "match" : "val_double",
                        "mapping": { 
                            "type": "double", 
                            "index": "not_analyzed"
                        },
                        "match_mapping_type":"string" 
                     }
                }
             ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/_template/hbase_jmx_template" -d'
{
    "template": "*-hbase-jmx-metrics-*",
    "mappings": {
        "_default_": {
            "dynamic_templates": [
                {
                    "name_field" : { 
                        "match" : "name",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        		{
                    "host_field" : { 
                        "match" : "host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        	{
                    "metric_path_field" : { 
                        "match" : "metric_path",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
                 {
                    "valstr_field" : { 
                        "match" : "val_str",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                },
                {
                    "valdouble_field" : { 
                        "match" : "val_double",
                        "mapping": { 
                            "type": "double", 
                            "index": "not_analyzed"
                        },
                        "match_mapping_type":"string" 
                     }
                }
             ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/_template/zookeeper_jmx_template" -d'
{
    "template": "*-zookeeper-jmx-metrics-*",
    "mappings": {
        "_default_": {
            "dynamic_templates": [
                {
                    "name_field" : { 
                        "match" : "name",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        		{
                    "host_field" : { 
                        "match" : "host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        	{
                    "metric_path_field" : { 
                        "match" : "metric_path",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
                 {
                    "valstr_field" : { 
                        "match" : "val_str",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                },
                {
                    "valdouble_field" : { 
                        "match" : "val_double",
                        "mapping": { 
                            "type": "double", 
                            "index": "not_analyzed"
                        },
                        "match_mapping_type":"string" 
                     }
                }
             ]
        }
    }
}'


curl -XPUT "http://$HOST_PORT/_template/flume_jmx_template" -d'
{
    "template": "*-flume-jmx-metrics-*",
    "mappings": {
        "_default_": {
            "dynamic_templates": [
                {
                    "name_field" : { 
                        "match" : "name",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        		{
                    "host_field" : { 
                        "match" : "host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        	{
                    "metric_path_field" : { 
                        "match" : "metric_path",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
                 {
                    "valstr_field" : { 
                        "match" : "val_str",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                },
                {
                    "valdouble_field" : { 
                        "match" : "val_double",
                        "mapping": { 
                            "type": "double", 
                            "index": "not_analyzed"
                        },
                        "match_mapping_type":"string" 
                     }
                }
             ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/_template/hbase_ganglia_template" -d'
{
    "template": "*-hbase-ganglia-metrics-*",
    "mappings": {
        "_default_": {
            "dynamic_templates": [
                {
                    "name_field" : { 
                        "match" : "name",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        		{
                    "host_field" : { 
                        "match" : "host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        		{
                    "loghost_field" : { 
                        "match" : "log_host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
                 {
                    "valstr_field" : { 
                        "match" : "val_str",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                },
                {
                    "valdouble_field" : { 
                        "match" : "val_double",
                        "mapping": { 
                            "type": "double", 
                            "index": "not_analyzed"
                        },
                        "match_mapping_type":"string" 
                     }
                }
             ]
        }
    }
}'


curl -XPUT "http://$HOST_PORT/_template/flume_ganglia_template" -d'
{
    "template": "*-flume-ganglia-metrics-*",
    "mappings": {
        "_default_": {
            "dynamic_templates": [
                {
                    "name_field" : { 
                        "match" : "name",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                 },
            {
                    "host_field" : { 
                        "match" : "host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
            {
                    "loghost_field" : { 
                        "match" : "log_host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
                 {
                    "valstr_field" : { 
                        "match" : "val_str",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                },
                {
                    "valdouble_field" : { 
                        "match" : "val_double",
                        "mapping": { 
                            "type": "double", 
                            "index": "not_analyzed"
                        },
                        "match_mapping_type":"string" 
                     }
                }
             ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/_template/elasticsearch_http_template" -d'
{
    "template": "*-elasticsearch-http-metrics-*",
    "mappings": {
        "_default_": {
            "dynamic_templates": [
                {
                    "name_field" : { 
                        "match" : "name",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                 },
            {
                    "host_field" : { 
                        "match" : "host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
            {
                    "loghost_field" : { 
                        "match" : "log_host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
                 {
                    "valstr_field" : { 
                        "match" : "val_str",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                },
                {
                    "valdouble_field" : { 
                        "match" : "val_double",
                        "mapping": { 
                            "type": "double", 
                            "index": "not_analyzed"
                        },
                        "match_mapping_type":"string" 
                     }
                }
             ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/_template/tajo_jmx_template" -d'
{
    "template": "*-tajo-jmx-metrics-*",
    "mappings": {
        "_default_": {
            "dynamic_templates": [
                {
                    "name_field" : { 
                        "match" : "name",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                 },
            		{
                    "host_field" : { 
                        "match" : "host",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
        	{
                    "metric_path_field" : { 
                        "match" : "metric_path",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            } 
                        },
                        "match_mapping_type":"string" 
                     }
                 },
                 {
                    "valstr_field" : { 
                        "match" : "val_str",
                        "mapping": { 
                            "type": "string", 
                            "index": "not_analyzed",
                            "fields": {
                                "raw":   { "type": "string", "index": "analyzed" }
                            }
                        },
                        "match_mapping_type":"string" 
                     }
                },
                {
                    "valdouble_field" : { 
                        "match" : "val_double",
                        "mapping": { 
                            "type": "double", 
                            "index": "not_analyzed"
                        },
                        "match_mapping_type":"string" 
                     }
                }
             ]
        }
    }
}'
