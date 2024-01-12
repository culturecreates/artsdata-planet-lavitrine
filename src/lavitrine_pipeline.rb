#!/usr/bin/env ruby

require_relative './utils/artsdata'

def LavitrinePipeline(**args)
  
  pipeline = ArtsdataPipeline.new

  artifact = ''
  if args[:graph]
    graph = args[:graph]
    artifact = graph.split("/").last
    puts "Downloading data..."
    pipeline.load(sparql: "./sparql/load_artsdata_events.sparql", limit: 30, graph: graph)
    pipeline.dump("../output/raw-#{artifact}.json")
  else
    file = args[:file]
    artifact = file.split("/").last.split(".").first
    puts "Loading file..."
    pipeline.load(file: file)
  end

  #### pipeline.load(file: "../output/raw-#{graph.split("/").last}.json" )
  # Custom transformations that justify needing this code rather than using solely the Artsdata API. 
  puts "Starting transforms..."
  pipeline.transform("./sparql/remove_blank_literals.sparql")
  pipeline.transform("./sparql/transform_single_events.sparql")
  pipeline.transform("./sparql/transform_series_events.sparql")
  pipeline.transform("./sparql/remove_eventforindex.sparql")
  pipeline.transform("./sparql/remove_temporary_eventtype.sparql")
  pipeline.transform("./sparql/convert_image_object_to_url.sparql")
  pipeline.transform("./sparql/convert_image_literal_to_uri.sparql")
  pipeline.transform("./sparql/convert_url_literal_to_uri.sparql")
  pipeline.transform("./sparql/convert_sameas_literal_to_uri.sparql")
  pipeline.transform("./sparql/convert_offers_to_aggregate_offer.sparql")
  pipeline.transform("./sparql/remove_footlight_aggregate_offer.sparql")
  pipeline.transform("./sparql/fix_aggregate_offer_url.sparql")
  pipeline.transform("./sparql/fix_aggregate_offers_missing_url.sparql")
  pipeline.transform("./sparql/remove_blank_literals.sparql")
  

  pipeline.dump("../output/transformed-#{artifact}.json")

  ##### pipeline.load(file: "../output/transformed-#{graph.split("/").last}.json" )

  puts "Framing..."
  pipeline.frame( "../frame/lavitrine_event_frame.jsonld")

  puts "Saving JSON-LD..."
  pipeline.dump("../output/#{artifact}.json")

  puts "Validating shapes... #{artifact}"
  pipeline.validate("../shacl/lavitrine_event_shacl.ttl","../shacl/lavitrine_offer_shacl.ttl")
  pipeline.report("../output/#{artifact}.yml")
end



