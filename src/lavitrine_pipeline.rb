#!/usr/bin/env ruby

require_relative './utils/artsdata'

############
# LavitrinePipeline class
# 
# This class is used to create a pipeline for the Lavitrine project
# It uses the ArtsdataPipeline class to load, transform, frame, dump, validate, and report the data
# Parameters:
# - graph: the graph name in Artsdata to load the data from
# - artifact: OPTIONAL - the artifact to save the data to
#   If not provided, the artifact is set to the last part of the graph URL
# - file: OPTIONAL - when no graph is given then the data is loaded from the file
#############
def LavitrinePipeline(**args)
  pipeline = ArtsdataPipeline.new

  artifact = ''
  if args[:graph]
    graph = args[:graph]
    artifact = args[:artifact] ||= graph.split("/").last
    puts "#{Time.now}: Downloading #{artifact} data..."
    pipeline.load(sparql: "./sparql/load_artsdata_events.sparql", limit: 10, graph: graph)
    pipeline.dump("../output/raw-#{artifact}.json")
  else
    file = args[:file]
    artifact = args[:artifact] ||= file.split("/").last.split(".").first
    puts "#{Time.now}: Loading #{artifact} file..."
    pipeline.load(file: file)
  end

  #### pipeline.load(file: "../output/raw-#{graph.split("/").last}.json" )
  # Custom transformations that justify needing this code rather than using solely the Artsdata API. 
  puts "#{Time.now}: Starting transforms..."
  pipeline.transform("./sparql/remove_blank_literals.sparql")
  puts "#{Time.now}: Starting transform transform_single_events..."
  pipeline.transform("./sparql/transform_single_events.sparql")
  puts "#{Time.now}: Starting transform transform_series_events..."
  pipeline.transform("./sparql/transform_series_events.sparql")
  puts "#{Time.now}: Starting transform transform_exhibitions..."
  pipeline.transform("./sparql/transform_exhibitions.sparql")
  puts "#{Time.now}: Starting small transforms..."
  pipeline.transform("./sparql/remove_eventforindex.sparql")
  pipeline.transform("./sparql/remove_temporary_eventtype.sparql")
  pipeline.transform("./sparql/convert_image_object_to_url.sparql")
  pipeline.transform("./sparql/convert_image_literal_to_uri.sparql")
  pipeline.transform("./sparql/convert_url_literal_to_uri.sparql")
  pipeline.transform("./sparql/convert_sameas_literal_to_uri.sparql")
  puts "#{Time.now}: Starting transform convert_offers_to_aggregate_offer..."
  pipeline.transform("./sparql/convert_offers_to_aggregate_offer.sparql")
  puts "#{Time.now}: Starting transform remove_footlight_aggregate_offer..."
  pipeline.transform("./sparql/remove_footlight_aggregate_offer.sparql")
  puts "#{Time.now}: Starting transform fix_aggregate_offer_url..."
  pipeline.transform("./sparql/fix_aggregate_offer_url.sparql")
  puts "#{Time.now}: Starting transform fix_aggregate_offers_missing_url..."
  pipeline.transform("./sparql/fix_aggregate_offers_missing_url.sparql")
  puts "#{Time.now}: Starting transform remove_blank_literals..."
  pipeline.transform("./sparql/remove_blank_literals.sparql")


  pipeline.dump("../output/transformed-#{artifact}.json")
  
  if pipeline.graph_empty?
    abort("Graph is empty. Aborting to signal to GitHub Actions that the workflow should be halted to avoid uploading empty data.")
  end
  
  #### pipeline.load(file: "../output/transformed-#{graph.split("/").last}.json" )

  puts "#{Time.now}: Framing..."
  pipeline.frame( ["../frame/lavitrine_event_frame.jsonld","../frame/lavitrine_exposition_frame.jsonld"])

  puts "#{Time.now}: Saving JSON-LD..."
  pipeline.dump("../output/#{artifact}.json")

  puts "#{Time.now}: Validating shapes... #{artifact}"
  pipeline.validate(
    "../shacl/lavitrine_event_shacl.ttl",
    "../shacl/lavitrine_offer_shacl.ttl"
    )
  puts "#{Time.now}: Listing missing artsdata ids... #{artifact}"
  pipeline.report_artsdata_ids("../output/#{artifact}-missing-artsdata-ids.txt")
  
  pipeline.report("../output/#{artifact}.yml")
  puts "#{Time.now}: Done with #{artifact}"
end

# Check if a parameter is provided
if ARGV.length == 0
  puts "Usage: ruby lavitrine_pipeline.rb <graph> [<artifact>]"
  exit
end

# Get the graph parameter
graph = ARGV[0]
artifact = ARGV[1]

# Call the LavitrinePipeline method with the graph parameter and optional artifact parameter
if graph
  LavitrinePipeline(graph: graph, artifact: artifact)
end

