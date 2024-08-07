require 'minitest/autorun'
require 'rdf'
require 'shacl'
require 'rdf/turtle'

class ShaclTest < Minitest::Test
  def setup
    shapes_graph = RDF::Graph.load('./shacl/lavitrine_event_shacl.ttl')
    shapes_graph << RDF::Graph.load('./shacl/lavitrine_offer_shacl.ttl')
    @shacl = SHACL.get_shapes(shapes_graph)
  end

  def test_full_event_should_pass
    graph = RDF::Graph.load("./tests/fixtures/full_event.jsonld")
    report =  @shacl.execute(graph)  
    # puts report
    assert report.conform?
  end

  def test_minimal_event_should_pass
    graph = RDF::Graph.load("./tests/fixtures/minimal_event.jsonld")
    report =  @shacl.execute(graph)  
    # puts report
    assert report.conform?
  end

  def test_no_subevent_fail
    graph = RDF::Graph.load("./tests/fixtures/missing_subevent.jsonld")
    report =  @shacl.execute(graph)  
    # puts report
    assert !report.conform?
  end

  def test_no_performer_pass
    graph = RDF::Graph.load("./tests/fixtures/missing_performer.jsonld")
    report =  @shacl.execute(graph)  
    # puts report
    assert report.conform?
  end

  def test_two_offers_fails
    graph = RDF::Graph.load("./tests/fixtures/two_offers.jsonld")
    report =  @shacl.execute(graph)  
    # puts report
    assert !report.conform?
  end

  def test_led_zepplin
    graph = RDF::Graph.load("./tests/fixtures/output_led_zepplin.jsonld")
    # pp JSON.parse(graph.dump(:jsonld, standard_prefixes: true))
    report =  @shacl.execute(graph)  
    # puts report
    assert report.conform?
  end


end