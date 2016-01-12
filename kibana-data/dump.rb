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

if ARGV.length < 4
	print "usage: ruby dump.rb <server host:port> <name pattern> <protocol pattern> <target file name>"
	exit(1)
end
server_hostport = ARGV[0]
name_pattern=ARGV[1]
protocol_pattern=ARGV[2]
target_filename=ARGV[3]


server_uri_string = "http://%s/.kibana/_search" % server_hostport
uri = URI.parse(server_uri_string)

header = { 'Content-Type' => 'text/json' }
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri, header)

request_json = {
  "filter"=> {
    "and"=> {
       "filters"=> [
       {
          "or"=> [
                 { "type"=> { "value"=> "dashboard" } },
                 { "type"=> { "value"=> "visualization" } },
                 { "type"=> { "value"=> "index-pattern" } }
           ]
        },
        { "term"=> {"title"=> name_pattern} },
        { "term"=> { "title"=> protocol_pattern}   }
        ]
    }
  },
  "size"=> 1000
}
# request_json = {"filter" => { "or" => [ {"type" => {"value" => "dashboard"}}, {"type" => {"value" => "visualization"}}, {"type" => {"value"=>"index-pattern"} }] }, "size" => 1000 }
request.body = JSON.generate(request_json)
res = http.request(request)

puts "dump response: %d %s" % [res.code, res.message]

if !res.is_a?(Net::HTTPSuccess)
	puts "error to dump kibana"
	exit 1
end

dumped_json = JSON.parse(res.body)
output_obj = []
dumped_json['hits']['hits'].each do |obj|
	puts obj
	out = { :_id => obj['_id'], :_type => obj['_type'], :_source => obj['_source'] }
	output_obj.push(out)
end

File.open(target_filename, 'w') { |file| file.write(JSON.pretty_generate(output_obj)) }

puts "%s is created" % target_filename
exit
