require 'minitest/autorun'
require 'rdf'
require 'linkeddata'
require_relative '../utils/artsdata.rb'

class SparqlTest < Minitest::Test
  def setup
    @graph = RDF::Graph.load("./grandtheatre-qc-ca-part.json")
  end

  def test_that_event_for_index_is_removed
    sparql = "../sparql/remove_event_for_index.sparql"
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    assert_equal 254, graph.count
  end

  def test_transform_single_events
    sparql = "../sparql/transform_single_events.sparql"
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    assert_equal 265, graph.count
  end
end

