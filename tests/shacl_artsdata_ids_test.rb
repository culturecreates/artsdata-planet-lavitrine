require 'minitest/autorun'
require 'rdf'
require 'shacl'
require 'rdf/turtle'

class ShaclTest < Minitest::Test
  def setup
    @shacl = SHACL.open('./shacl/has_artsdata_ids_shacl.ttl')
  end

  def test_full_event_should_pass
    graph = RDF::Graph.load("./tests/fixtures/places_to_test_artsdata_ids.jsonld")
    # puts graph.dump(:jsonld)
    report =  @shacl.execute(graph)  
    
    # puts report
   
    assert report.conform?
  end
end