#!/usr/bin/env ruby

require_relative './utils/artsdata'

def LavirtrinePipeline(graph: "http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com")
  dump_file = graph.split("/").last + ".json"
  report_file = "report-" + graph.split("/").last + ".txt"
  graph_placeholder = "http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca"

  pipeline = ArtsdataPipeline.new

  puts "Downloading data..."
  # 1. load all uris
  # 2. inside graph expand 2 levels deep

  pipeline.load(sparql: "./sparql/load_artsdata_events.sparql", limit: 30, graph: graph, graph_placeholder: graph_placeholder)
   # 3. across graphs expand artsdata URIs (places, organizers,...)

   # TODO: 1. get unique adid and add to graph
  # pipeline.load(sparql: "./sparql/expand_artsdata_uris.sparql")
  pipeline.dump("temp-pda.jsonld")


  # Custom transformations that justify needing this code rather than using solely the Artsdata API. 
  puts "Starting transforms..."
  pipeline.transform("./sparql/transform_single_events.sparql")
  pipeline.transform("./sparql/remove_event_for_index.sparql")
  pipeline.transform("./sparql/convert_image_object_to_url.sparql")

  puts "Framing..."
  frame = "../frame/lavitrine_frame.jsonld"
  pipeline.frame(frame)

  puts "Saving JSON-LD..."
  pipeline.dump("../output/#{dump_file}")

  # puts "Validating shapes..."
  # pipeline.validate("../shacl/lavitrine_shacl.ttl")
  # pipeline.report("../output/#{report_file}")
end



