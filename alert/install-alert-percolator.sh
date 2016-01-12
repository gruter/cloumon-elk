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

curl -XPOST "$HOST_PORT/alert-percolator" -d'
{
    "mappings": {
        "metrics": {
            "properties": {
                "log_host": {
                    "type": "string",
                    "index": "not_analyzed" 
                },
                "host": {
                    "type": "string",
                    "index": "not_analyzed" 
                },
                "hostname": {
                    "type": "string",
                    "index": "not_analyzed" 
                },
                "name": {
                    "type": "string",
                    "index": "not_analyzed" 
                },
                "metric_name": {
                    "type": "string",
                    "index": "not_analyzed" 
                },
                "val_str": {
                    "type": "string",
                    "index": "not_analyzed" 
                },
                "val_double": {
                    "type": "float" 
                },
                "metric_value": {
                    "type": "float" 
                }
            }
        }
    }
}'

curl -XPOST "$HOST_PORT/delta-alert-percolator" -d'
{
    "mappings": {
        "metrics": {
            "properties": {
                "log_host": {
                    "type": "string",
                    "index": "not_analyzed" 
                },
                "host": {
                    "type": "string",
                    "index": "not_analyzed" 
                },
                "hostname": {
                    "type": "string",
                    "index": "not_analyzed" 
                },
                "name": {
                    "type": "string",
                    "index": "not_analyzed" 
                },
                "metric_name": {
                    "type": "string",
                    "index": "not_analyzed" 
                },
                "val_str": {
                    "type": "string",
                    "index": "not_analyzed" 
                },
                "val_double": {
                    "type": "float" 
                },
                "metric_value": {
                    "type": "float" 
                }
            }
        }
    }
}'
