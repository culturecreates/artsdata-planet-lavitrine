#!/usr/bin/env ruby

require_relative './utils/artsdata'

def LavirtrinePipeline(graph)
  
  pipeline = ArtsdataPipeline.new

  puts "Downloading data..."
  pipeline.load(sparql: "./sparql/load_artsdata_events.sparql", limit: 30, graph: graph)

  # Custom transformations that justify needing this code rather than using solely the Artsdata API. 
  puts "Starting transforms..."
  pipeline.transform("./sparql/transform_single_events.sparql")
  pipeline.transform("./sparql/remove_eventforindex.sparql")
  pipeline.transform("./sparql/convert_image_object_to_url.sparql")
  pipeline.transform("./sparql/convert_image_literal_to_uri.sparql")
  pipeline.transform("./sparql/convert_url_literal_to_uri.sparql")

  puts "Framing..."
  pipeline.frame( "../frame/lavitrine_frame.jsonld")

  puts "Saving JSON-LD..."
  pipeline.dump("../output/#{graph.split("/").last}.json")

  puts "Validating shapes..."
  pipeline.validate("../shacl/lavitrine_shacl.ttl")
  pipeline.report("../output/#{graph.split("/").last}.txt")
end



