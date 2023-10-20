#!/usr/bin/env ruby

require 'rdf'
require 'shacl'
require 'rdf/turtle'
require 'sparql/client'
require 'linkeddata'
require 'json/ld'

named_graph = "http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com"
placeholder_graph = "http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca"

puts "Downloading data..."
sparql_client = SPARQL::Client.new("http://db.artsdata.ca/repositories/artsdata")
graph = RDF::Graph.new # or test with this graph = RDF::Graph.load("./test/grandtheatre-qc-ca-part.json")
sparql = File.read("./sparql/load_artsdsata_events.sparql").gsub(placeholder_graph,named_graph)
for i in 0..8 do
  result = sparql_client.query(sparql.sub("limit 10 offset 0", "limit 30 offset #{i * 30}"))
  result.each_statement do |statement|
    graph << statement 
  end
  puts "Graph has #{graph.count} triples"
end


puts "Starting transforms..."
graph = graph.query(SPARQL.parse(File.read("./sparql/transform.sparql"), update: true))
# File.write("./output/1.jsonld", graph.dump(:jsonld))
graph = graph.query(SPARQL.parse(File.read("./sparql/remove_event_for_index.sparql"), update: true))
# File.write("./output/2.jsonld", graph.dump(:jsonld))

puts "JSON-LD Framing..."
frame = JSON.parse(File.read("../frame/lavitrine_frame.jsonld"))
input = JSON.parse(graph.dump(:jsonld))
framed_graph = JSON::LD::API.frame(input, frame)

puts "Saving JSON-LD..."
File.write("./output/framed.jsonld", framed_graph.to_json)

puts "Validating shapes..."
shacl = SHACL.open("../shacl/lavitrine_shacl.ttl")
report = shacl.execute(graph)
puts "Conforms: #{report.conform?}"

File.write("./output/report.txt", report) 


