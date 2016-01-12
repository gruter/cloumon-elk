require 'json'
require 'net/http'
require 'uri'

def get_file_as_string(filename)
	data = ''
	File.open(filename, 'r').each_line do |line|
		data += line	
	end
	return data
end

if ARGV.length < 2
	puts "usage: ruby restore.rb <server host:port> <jsonfile> <cluster name>"
	exit(1)
end
server_hostport = ARGV[0]
dump_filename=ARGV[1]
cluster_name=(ARGV[2])? ARGV[2] : 'default'


dumped_json = get_file_as_string dump_filename
dumped_json.gsub! '{cluster_name}', cluster_name 

if dumped_json.index('{cluster_name}')
  puts '{cluster_name} is not replaced'
  exit 1
end

kibana_objects = JSON.parse(dumped_json)
restore_request = ''

kibana_objects.each do |obj|
	op = { :index => { :_id => obj['_id'], :_type => obj['_type'] } }
	restore_request += JSON.generate(op) + "\n"
	restore_request += JSON.generate(obj['_source']) + "\n"
end

#  $ curl -XPOST localhost:9200/.kibana/_bulk -d '
#  {"index": {"_id": "Tajo-Worker-JVM-Heap-Max-slash-Used33", "_type": "visualization"} }
#  {    "title": "Tajo Worker JVM Heap Max/Used33",    "visState": "{\"type\":\"line\",\"params\":{\"shareYAxis\":true,\"addTooltip\":true,\"addLegend\":true,\"showCircles\":true,\"smoothLines\":false,\"interpolate\":\"linear\",\"scale\":\"linear\",\"drawLinesBetweenPoints\":true,\"radiusRatio\":9,\"times\":[],\"addTimeMarker\":false,\"defaultYExtents\":false,\"setYExtents\":false,\"yAxis\":{}},\"aggs\":[{\"id\":\"1\",\"type\":\"sum\",\"schema\":\"metric\",\"params\":{\"field\":\"val_double\"}},{\"id\":\"2\",\"type\":\"date_histogram\",\"schema\":\"segment\",\"params\":{\"field\":\"formatted_timestamp\",\"interval\":\"m\",\"customInterval\":\"2h\",\"min_doc_count\":1,\"extended_bounds\":{}}},{\"id\":\"3\",\"type\":\"terms\",\"schema\":\"group\",\"params\":{\"field\":\"name.raw\",\"size\":5,\"order\":\"desc\",\"orderBy\":\"1\"}},{\"id\":\"4\",\"type\":\"terms\",\"schema\":\"split\",\"params\":{\"field\":\"log_host.raw\",\"size\":20,\"order\":\"desc\",\"orderBy\":\"1\",\"row\":false}}],\"listeners\":{}}",    "description": "",    "version": 1,    "kibanaSavedObjectMeta": {        "searchSourceJSON": "{\"index\":\"logstash-*\",\"query\":{\"query_string\":{\"query\":\"name.raw:worker-jvm.Heap.heap.max or name.raw:worker-jvm.Heap.heap.used\",\"analyze_wildcard\":true}},\"filter\":[]}"    }}

server_uri_string = "http://%s/.kibana/_bulk" % server_hostport
uri = URI.parse(server_uri_string)
header = { 'Content-Type' => 'text/json' }
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri, header)
request.body = restore_request

response = http.request(request)
puts "restore response: %d %s" % [response.code, response.message]

