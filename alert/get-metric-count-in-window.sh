#!/usr/bin/env bash

if [ $# -lt 3 ]; then
cat <<EOF
  usage: `basename $0` <elasticsearch url> <index name> <n minutes>
    <elasticsearch url> requires http url
    <index name> is the name to search <query string>
    <n minutes> is size of window to query

    example) $0 http://localhost:9200 system-http-metrics 10"
EOF
  exit 1
fi

ELASTICSEARCH_URL=$1
INDEX_NAME=$2
WINDOW_SIZE=$3
shift 3

SYSTEM_NAME=`uname -s`

TODAY=`date -u +%Y.%m.%d`
YESTERDAY=$(case $SYSTEM_NAME in
  ("Linux") echo `date -u +%Y.%m.%d -d "a day ago"`;;
  ("Darwin") echo `date -u -v-1d +%Y.%m.%d`;;
  (*) echo "" ;;
esac)


NOW=`date -u +%Y-%m-%dT%T`
N_MINUTE_AGO=$(case $SYSTEM_NAME in
  ("Linux") echo `date -u +%Y-%m-%dT%T -d "${WINDOW_SIZE} min ago"`;;
  ("Darwin") echo `date -u -v-${WINDOW_SIZE}M +%Y-%m-%dT%T`;;
  (*) echo "" ;;
esac)

# checking index exists
YESTERDAY_EXISTS=`curl -s -XGET "$ELASTICSEARCH_URL/${INDEX_NAME}-${YESTERDAY}"|grep IndexMissingException `
TODAY_EXISTS=`curl -s -XGET "$ELASTICSEARCH_URL/${INDEX_NAME}-${TODAY}"|grep IndexMissingException`

if [ "$YESTERDAY_EXISTS" ] && [ "$TODAY_EXISTS" ]; then
  echo "{}"
  exit 2
fi

if [ -z "$YESTERDAY_EXISTS" ]; then
  SEARCH_INDEX="${INDEX_NAME}-${YESTERDAY}"
fi

if [ -z "$TODAY_EXISTS" ]; then
  if [ "$SEARCH_INDEX" ]; then
    SEARCH_INDEX="${SEARCH_INDEX},"
  fi
  SEARCH_INDEX="${SEARCH_INDEX}${INDEX_NAME}-${TODAY}"
fi

case $INDEX_NAME in
("system-http-metrics")
HOST_FIELD="hostname"
METRIC_NAME_FIELD="metric_name"
;;
(*"-ganglia-metrics")
HOST_FIELD="log_host"
METRIC_NAME_FIELD="name"
;;
(*"-jmx-metrics")
HOST_FIELD="host"
METRIC_NAME_FIELD="name"
;;
(*)
HOST_FIELD="host"
METRIC_NAME_FIELD="name"
;;
esac

QUERY_DSL=`cat<<EOF
{
    "query": {
        "range": {
           "@timestamp": {
              "gte": "$N_MINUTE_AGO",
              "lt": "$NOW"
           }
        }
    },
    "aggs": {
        "host": {
            "terms": {
                "field": "$HOST_FIELD",
                "size": 3000
            },
            "aggs": {
                "by_name": {
                    "terms": {
                        "field": "$METRIC_NAME_FIELD",
                        "size": 3000
                    }
                }
            }
        }
    }
}
EOF
`
curl -s -XGET "$ELASTICSEARCH_URL/${SEARCH_INDEX}/_search" -d"$QUERY_DSL" 

