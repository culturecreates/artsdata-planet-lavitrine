require 'minitest/autorun'
require 'rdf'
require 'linkeddata'
require 'shacl'

class ShaclTest < Minitest::Test
  def setup
    @shacl_file = "../../shacl/lavitrine_shacl.ttl"
    @shacl = SHACL.open(@shacl_file)
  end

  def test_full_event_should_pass
    graph = RDF::Graph.load("./fixtures/full_event.jsonld")
    report =  @shacl.execute(graph)  
    # puts report
    assert report.conform?
  end

  def test_minimal_event_should_pass
    graph = RDF::Graph.load("./fixtures/minimal_event.jsonld")
    report =  @shacl.execute(graph)  
    # puts report
    assert report.conform?
  end

  def test_no_subevent_fail
    graph = RDF::Graph.load("./fixtures/missing_subevent.jsonld")
    report =  @shacl.execute(graph)  
    # puts report
    assert !report.conform?
  end

  def test_no_performer_pass
    graph = RDF::Graph.load("./fixtures/missing_performer.jsonld")
    report =  @shacl.execute(graph)  
    # puts report
    assert report.conform?
  end
end