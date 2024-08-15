#!/usr/bin/env ruby

require_relative './utils/artsdata'

def LavitrinePipeline(**args)
  
  pipeline = ArtsdataPipeline.new

  #################
  # Loading
  #################

  artifact = ''
  if args[:graph]
    graph = args[:graph]
    artifact = graph.split("/").last
    puts "#{Time.now}: Downloading #{artifact} data..."
    pipeline.load(sparql: "./sparql/load_artsdata_events.sparql", limit: 10, graph: graph)
    pipeline.dump("../output/raw-#{artifact}.json")
  else
    file = args[:file]
    artifact = file.split("/").last.split(".").first
    puts "#{Time.now}: Loading #{artifact} file..."
    pipeline.load(file: file)
  end

  ################# 
  # Transforming
  # Custom transformations that justify needing this code rather than using solely the Artsdata API. 
  # Groups must be run in order.
  # --> shortcut start to here:  pipeline.load(file: "../output/raw-#{graph.split("/").last}.json" )
  #################

  ## group A 
  puts "#{Time.now}: Starting group A transforms..."
  sparql_files = Dir.glob("src/sparql/transformations/group_a/*.sparql")
  pipeline.transform(*sparql_files)

  ## group B
  puts "#{Time.now}: Starting group B transforms..."
  sparql_files = Dir.glob("src/sparql/transformations/group_b/*.sparql")
  pipeline.transform(*sparql_files)

  ## group C
  puts "#{Time.now}: Starting group C transforms..."
  sparql_files = Dir.glob("src/sparql/transformations/group_c/*.sparql")
  pipeline.transform(*sparql_files)

  ## group D
  puts "#{Time.now}: Starting group D transforms..."
  sparql_files = Dir.glob("src/sparql/transformations/group_d/*.sparql")
  pipeline.transform(*sparql_files)

  pipeline.dump("../output/transformed-#{artifact}.json")

  #################
  # Framing
  # --> shortcut start to here:  pipeline.load(file: "../output/transformed-#{graph.split("/").last}.json" )
  #################

  puts "#{Time.now}: Framing..."
  pipeline.frame( "../frame/lavitrine_event_frame.jsonld")

  puts "#{Time.now}: Saving JSON-LD..."
  pipeline.dump("../output/#{artifact}.json")

  #################
  # SHACL Validation
  #################

  puts "#{Time.now}: Validating shapes... #{artifact}"
  # Get all Turtle files in the /shacl/ directory
  shacl_files = Dir.glob("shacl/*.ttl")

  # Validate all the SHACL files
  pipeline.validate(*shacl_files)

  puts "#{Time.now}: Listing missing artsdata ids... #{artifact}"
  pipeline.report_artsdata_ids("../output/#{artifact}-missing-artsdata-ids.txt")
  
  pipeline.report("../output/#{artifact}.yml")
  puts "#{Time.now}: Done with #{artifact}"
end



