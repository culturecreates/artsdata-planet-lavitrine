#!/usr/bin/env ruby

require_relative './utils/artsdata'

def LavitrinePipeline()
  
  pipeline = ArtsdataPipeline.new

    # puts "Downloading data..."
    pipeline.load(sparql: "./sparql/load_artsdata_organizations.sparql", limit: 30)
    pipeline.dump("../output/raw-organizations.json")

end


LavitrinePipeline()