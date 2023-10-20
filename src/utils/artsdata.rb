#!/usr/bin/env ruby

require 'sparql/client'
require 'rdf'
require 'shacl'
require 'rdf/turtle'

require 'linkeddata'
require 'json/ld'

class ArtsdataPipeline
  attr_accessor :sparql_client, :graph, :framed_graph, :report
  def initialize
    @sparql_client = SPARQL::Client.new("http://db.artsdata.ca/repositories/artsdata")
  end

  def load(sparql:, graph:, graph_placeholder:)
    @graph = RDF::Graph.new
    sparql = File.read(sparql).gsub(graph_placeholder,graph)
    for i in 0..8 do
      result = sparql_client.query(sparql.sub("limit 10 offset 0", "limit 30 offset #{i * 30}"))
      result.each_statement do |statement|
        @graph << statement 
      end
      puts "Graph has #{@graph.count} triples"
    end
  end

  def transform(sparql)
    @graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
  end

  def frame(frame)
    frame = JSON.parse(File.read(frame))
    input = JSON.parse(@graph.dump(:jsonld))
    @framed_graph = JSON::LD::API.frame(input, frame)
  end

  def dump(file)
    if @framed_graph
      File.write(file, @framed_graph.to_json)
    elsif @graph
      File.write(file, @graph.dump(:jsonld).to_json)
    end
  end

  def validate(shacl)
    shacl = SHACL.open(shacl)
    @report = shacl.execute(@graph)  
    puts "Conforms: #{@report.conform?}"
  end

  def report(file)
    File.write(file, @report)
  end

end