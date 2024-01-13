#!/usr/bin/env ruby

require_relative 'lavitrine_pipeline.rb'

LavitrinePipeline(graph: "http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com")
LavitrinePipeline(graph: "http://kg.artsdata.ca/resource/dia-logGraphs") 
LavitrinePipeline(graph: "http://kg.artsdata.ca/culture-creates/footlight/hector-charland-com")
LavitrinePipeline(graph: "http://kg.artsdata.ca/culture-creates/footlight/theatredumarais-com")
LavitrinePipeline(graph: "http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca")
LavitrinePipeline(graph: "http://kg.artsdata.ca/culture-creates/artsdata-planet-footlight/tout-culture-cms-events")
