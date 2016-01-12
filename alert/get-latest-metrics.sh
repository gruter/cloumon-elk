#!/usr/bin/env bash

print_help() {
  cat <<EOF
  usage: `basename $0` <elasticsearch url> <index name> "<value field name>" "<query string 1>" ... "<query string n>"
    <elasticsearch url> requires http url
    <index name> is the name to search <query string>
    <value field name> will be set as default field to search, optional
    <query string>s will join with OR operator, optional

    example) $0 http://localhost:9200 system-http-metrics # listing all the metrics within last two minutes
    example) $0 http://localhost:9200 system-http-metrics metric_value "metric_name:cpu.usage AND >50" "metric_name:memory.actual.free AND <30" # listing matched metrics within last two minutes
EOF
}

if [ $# -eq 2 ]; then
  SEARCH_TYPE="all"
elif [ $# -ge 4 ]; then
  SEARCH_TYPE="search"
else
  SEARCH_TYPE="no_supported"
fi

if [ "$SEARCH_TYPE" = "no_supported" ]; then
  print_help
  exit 1
fi

ELASTICSEARCH_URL=$1
INDEX_NAME=$2

if [ "$SEARCH_TYPE" = "search" ]; then
  VALUE_FIELD_NAME=$3
  shift 3

  QUERIES=
  for arg; do
    if [ -z "$QUERIES" ]; then
      QUERIES="($arg)"
    else
      QUERIES="$QUERIES OR ($arg)"
    fi
  done
fi



SYSTEM_NAME=`uname -s`

TODAY=`date -u +%Y.%m.%d`
YESTERDAY=$(case $SYSTEM_NAME in
  ("Linux") echo `date -u +%Y.%m.%d -d "a day ago"`;;
  ("Darwin") echo `date -u -v-1d +%Y.%m.%d`;;
  (*) echo "" ;;
esac)


NOW=`date -u +%Y-%m-%dT%T`
TWO_MINUTE_AGO=$(case $SYSTEM_NAME in
  ("Linux") echo `date -u +%Y-%m-%dT%T -d "2 min ago"`;;
  ("Darwin") echo `date -u -v-1M +%Y-%m-%dT%T`;;
  (*) echo "" ;;
esac)

# checking index exists
YESTERDAY_NOT_EXISTS=`curl -s -XGET "$ELASTICSEARCH_URL/${INDEX_NAME}-${YESTERDAY}"|grep IndexMissingException `
TODAY_NOT_EXISTS=`curl -s -XGET "$ELASTICSEARCH_URL/${INDEX_NAME}-${TODAY}"|grep IndexMissingException`

if [ "$YESTERDAY_NOT_EXISTS" ] && [ "$TODAY_NOT_EXISTS" ]; then
  echo "{}"
  exit 2
fi

if [ -z "$YESTERDAY_NOT_EXISTS" ]; then
  SEARCH_INDEX="${INDEX_NAME}-${YESTERDAY}"
fi

if [ -z "$TODAY_NOT_EXISTS" ]; then
  if [ "$SEARCH_INDEX" ]; then
    SEARCH_INDEX="${SEARCH_INDEX},"
  fi
  SEARCH_INDEX="${SEARCH_INDEX}${INDEX_NAME}-${TODAY}"
fi

if [ "$SEARCH_TYPE" = "all" ]; then
  QUERY_DSL=`cat<<EOF
{
   "query": {
        "range": {
           "@timestamp": {
              "gte": "$TWO_MINUTE_AGO",
              "lt": "$NOW"
           }
        }
    },
    "sort": [
       {
          "@timestamp": {
             "order": "desc"
          }
       }
    ], 
    "size": 500000
}
EOF
`
elif [ "$SEARCH_TYPE" = "search" ]; then
  QUERY_DSL=`cat<<EOF
{
  "query": {
    "bool": {
      "must": [
         {
           "query_string": {
             "default_field": "$VALUE_FIELD_NAME", 
             "query": "$QUERIES"
           }
         },
         {
           "range": {
              "@timestamp": {
                "gte": "$TWO_MINUTE_AGO",
                "lt": "$NOW"
              }
            }
         }
      ]
    }
  },
  "sort": [
     {
       "@timestamp": {
         "order": "desc"
       }
     }
  ],
  "size": 50000
}
EOF
`
else
  print_help
  exit 1
fi
curl -s -XGET "$ELASTICSEARCH_URL/${SEARCH_INDEX}/_search" -d"$QUERY_DSL" 
