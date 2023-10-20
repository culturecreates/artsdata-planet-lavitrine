#!/usr/bin/env ruby

require_relative './utils/artsdata'

def LavirtrinePipeline(graph = "http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com")
  dump_file = graph.split("/").last + ".jsonld"
  report_file = "report-" + graph.split("/").last + ".txt"
  graph_placeholder = "http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca"

  pipeline = ArtsdataPipeline.new

  puts "Downloading data..."
  pipeline.load(sparql: "./sparql/load_artsdsata_events.sparql", graph: graph, graph_placeholder: graph_placeholder)

  # Custom transformations that justify needing this code rather than using solely the Artsdata API. 
  puts "Starting transforms..."
  pipeline.transform("./sparql/transform_single_events.sparql")
  pipeline.transform("./sparql/remove_event_for_index.sparql")

  puts "Framing..."
  frame = "../frame/lavitrine_frame.jsonld"
  pipeline.frame(frame)

  puts "Saving JSON-LD..."
  pipeline.dump("./output/#{dump_file}")

  puts "Validating shapes..."
  pipeline.validate("../shacl/lavitrine_shacl.ttl")
  pipeline.report("./output/#{report_file}")
end



