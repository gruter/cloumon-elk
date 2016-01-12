#!/usr/bin/env bash

print_help() {
  cat <<EOF
  usage: `basename "$0"` <host:port>
EOF
}

if [ $# -lt 1 ]; then
  print_help
  exit 1
fi

HOST_PORT=$1

curl -XPUT "$HOST_PORT/alert-percolator/.percolator/cpu-usage" -d'
{
    "query": {
        "bool": {
            "must": [
               {
                   "terms": {
                       "metric_name": [
                          "cpu.usage" 
                       ]
                    }
               },
               {
                    "range": {
                       "metric_value": {
                          "gte": 80
                       }
                    }
               }
            ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/alert-percolator/.percolator/disk-usage-greater-than" -d'
{
    "query": {
        "bool": {
            "must": [
               {
                   "query_string": {
                       "query": "metric_name:disk.*.use.percent" 
                    }
               },
               {
                    "range": {
                       "metric_value": {
                          "gte": 90
                       }
                    }
               }
            ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/alert-percolator/.percolator/hadoop-volume-failures" -d'
{
    "query": {
        "bool": {
            "must": [
               {
                   "wildcard": {
                       "name": "*VolumeFailures" 
                    }
               },
               {
                    "range": {
                       "val_double": {
                          "gte": 1
                       }
                    }
               }
            ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/alert-percolator/.percolator/hadoop-namenode-heap-used" -d'
{
    "query": {
        "bool": {
            "must": [
               {
                   "query_string": {
                       "query": "host:host002 AND (name:JvmMetrics.MemHeapUsedM)" 
                    }
               },
               {
                    "range": {
                       "val_double": {
                          "gte": 3000
                       }
                    }
               }
            ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/alert-percolator/.percolator/flume-channel-usage" -d'
{
    "query": {
        "bool": {
            "must": [
               {
                   "wildcard": {
                       "name": "*.ChannelFillPercentage" 
                    }
               },
               {
                    "range": {
                       "val_double": {
                          "gte": 95
                       }
                    }
               }
            ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/alert-percolator/.percolator/hbase-dead-regionserver" -d'
{
    "query": {
        "bool": {
            "must": [
               {
                   "term": {
                      "name": {
                         "value": "Master.Server.numDeadRegionServers" 
                      }
                   }
               },
               {
                    "range": {
                       "val_double": {
                          "gte": 1
                       }
                    }
               }
            ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/alert-percolator/.percolator/hbase-rit-count-over-threshold" -d'
{
    "query": {
        "bool": {
            "must": [
               {
                    "term": {
                      "name": {
                         "value": "Master.AssignmentManger.ritCountOverThreshold" 
                      }
                   }
               },
               {
                    "range": {
                       "val_double": {
                          "gte": 1
                       }
                    }
               }
            ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/alert-percolator/.percolator/tajo-dead-worker" -d'
{
    "query": {
        "bool": {
            "must": [
               {
                    "term": {
                      "name": {
                         "value": "MASTER.CLUSTER.LOST_NODES" 
                      }
                   }
               },
               {
                    "range": {
                       "val_double": {
                          "gte": 1
                       }
                    }
               }
            ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/alert-percolator/.percolator/zookeeper-outstanding-requests" -d'
{
    "query": {
        "bool": {
            "must": [
               {
                    "wildcard": {
                      "name": "*.OutstandingRequests" 
                   }
               },
               {
                    "range": {
                       "val_double": {
                          "gte": 1
                       }
                    }
               }
            ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/delta-alert-percolator/.percolator/elasticsearch-thread-pool-rejected" -d'
{
    "query": {
        "bool": {
            "must": [
               {
                    "wildcard": {
                      "name": "stats.nodes.*.thread_pool*rejected" 
                   }
               },
               {
                    "range": {
                       "val_double": {
                          "gte": 1
                       }
                    }
               }
            ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/alert-percolator/.percolator/elasticsearch-cpu-usage" -d'
{
    "query": {
        "bool": {
            "must": [
               {
                    "wildcard": {
                      "name": "stats.nodes.*.os.cpu.usage" 
                   }
               },
               {
                    "range": {
                       "val_double": {
                          "gte": 70
                       }
                    }
               }
            ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/delta-alert-percolator/.percolator/hadoop-error-log-count" -d'
{
    "query": {
        "bool": {
            "must": [
               {
                    "query_string": {
                       "query": "name:JvmMetrics.LogError OR name:JvmMetrics.LogFatal" 
                    }
               },
               {
                    "range": {
                       "val_double": {
                          "gte": 1
                       }
                    }
               }
            ]
        }
    }
}'

curl -XPUT "http://$HOST_PORT/delta-alert-percolator/.percolator/tajo-error-log-count" -d'
{
    "query": {
        "bool": {
            "must": [
               {
                    "query_string": {
                       "query": "name:(MASTER-JVM.LOG.Error OR MASTER-JVM.LOG.Fatal OR NODE-JVM.LOG.Fatal OR NODE-JVM.LOG.Error)" 
                    }
               },
               {
                    "range": {
                       "val_double": {
                          "gte": 1
                       }
                    }
               }
            ]
        }
    }
}'
