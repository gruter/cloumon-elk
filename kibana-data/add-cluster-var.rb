require 'json'

if not ARGV[0]
  puts "Usage: " + __FILE__ + " <json file>"
  puts "  <json file> that is exported from kibana"
  exit 1
end

json_name=ARGV[0]
lines = File.read(json_name)

prefix='{cluster_name}-'
postfix='-{cluster_name}'
postfix_with_spaces=' - {cluster_name}'

obj = JSON.parse(lines)
kibana_objs = {}
kibana_dashboards = []
obj.each do |o|
  type = o['_type']
  id = o['_id'].clone

  if type == 'dashboard'
    kibana_dashboards.push o
    next
  end

  if type == 'index-pattern'
    o['_id'] = prefix + id
    o['_source']['title'] = prefix + o['_source']['title']
  elsif type == 'visualization'
    kso = o['_source']['kibanaSavedObjectMeta']
    ksos_obj = JSON.parse(kso['searchSourceJSON'])

    if ksos_obj.has_key?('index')
      o['_id'] = id + postfix
      o['_source']['title'] += postfix_with_spaces
      ksos_obj['index'] = prefix + ksos_obj['index'] 
      kso['searchSourceJSON'] = JSON.generate(ksos_obj)
    end
    kibana_objs[id] = o['_id']
  end
end

kibana_dashboards.each do |o|
  o['_id'] += postfix
  o['_source']['title'] += postfix_with_spaces

  pobj = JSON.parse(o['_source']['panelsJSON'])
  pobj.each do |oo|
    oo['id'] = kibana_objs[oo['id']]
  end
  o['_source']['panelsJSON'] = JSON.generate(pobj)
end

puts JSON.pretty_generate(obj)
