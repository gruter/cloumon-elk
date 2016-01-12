#!/bin/bash

if [ $# -lt 1 ]; then
  echo "usage: $0 <server ip:port>"
  exit
fi

HOST_PORT=$1
curl -XPUT "http://$HOST_PORT/.kibana/" -d'
{"mappings": {"dashboard":{"properties":{"description":{"type":"string"},"hits":{"type":"integer"},"kibanaSavedObjectMeta":{"properties":{"searchSourceJSON":{"type":"string"}}},"panelsJSON":{"type":"string"},"timeRestore":{"type":"boolean"},"title":{"type":"string"},"version":{"type":"integer"}}},"config":{"properties":{"buildNum":{"type":"string","index":"not_analyzed"},"defaultIndex":{"type":"string"}}},"index-pattern":{"properties":{"fieldFormatMap":{"type":"string"},"fields":{"type":"string"},"intervalName":{"type":"string"},"timeFieldName":{"type":"string"},"title":{"type":"string"}}},"visualization":{"properties":{"description":{"type":"string"},"kibanaSavedObjectMeta":{"properties":{"searchSourceJSON":{"type":"string"}}},"title":{"type":"string"},"version":{"type":"integer"},"visState":{"type":"string"}}},"search":{"properties":{"columns":{"type":"string"},"description":{"type":"string"},"hits":{"type":"integer"},"kibanaSavedObjectMeta":{"properties":{"searchSourceJSON":{"type":"string"}}},"sort":{"type":"string"},"title":{"type":"string"},"version":{"type":"integer"}}}}}'
