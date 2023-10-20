#!/usr/bin/env ruby

require 'rdf'
require 'shacl'
require 'rdf/turtle'

puts "Starting tests..."

graph = RDF::Graph.load("./framed_output.jsonld", format: :jsonld)
puts "Loaded graph with #{graph.count} triples."
shacl = SHACL.open("../shacl/lavitrine_shacl.ttl")
puts "Loaded shacl with #{shacl.count} triples."
report = shacl.execute(graph)

puts "Conforms: #{report.conform?}"

puts report 