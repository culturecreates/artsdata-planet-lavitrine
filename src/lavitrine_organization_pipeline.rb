#!/usr/bin/env ruby

require_relative './utils/artsdata'

def LavitrinePipeline(graph: "organizations")
  
  pipeline = ArtsdataPipeline.new

  puts "Downloading data..."
  pipeline.load(sparql: "./sparql/load_artsdata_organizations.sparql", limit: 30)
  pipeline.dump("../output/raw-organizations.json")

  puts "Starting transforms..."
  pipeline.transform("./sparql/convert_url_literal_to_uri.sparql")

  puts "Framing..."
  pipeline.frame("../frame/lavitrine_organization_frame.jsonld")

  puts "Saving JSON-LD..."
  pipeline.dump("../output/#{graph.split("/").last}.json")
end


LavitrinePipeline()