require 'minitest/autorun'
require 'rdf'
require 'shacl'
require 'rdf/turtle'

class ShaclTest < Minitest::Test
  def setup
    shacl_files = Dir.glob("shacl/*.ttl")
    shapes_graph = RDF::Graph.new
    shacl_files.each do |file|
      shapes_graph << RDF::Graph.load(file)
    end

    @shacl = SHACL.get_shapes(shapes_graph)
  end

  def test_full_event_should_pass
    graph = RDF::Graph.load("./tests/fixtures/full_event.jsonld")
    report =  @shacl.execute(graph)  
    assert report.conform?,"#{report}"
  end

  def test_minimal_event_should_pass
    graph = RDF::Graph.load("./tests/fixtures/minimal_event.jsonld")
    report =  @shacl.execute(graph)  
    assert report.conform?,"#{report}"
  end

  def test_no_subevent_fail
    graph = RDF::Graph.load("./tests/fixtures/missing_subevent.jsonld")
    report =  @shacl.execute(graph)  
    assert !report.conform?,"#{report}"
  end

  def test_no_performer_pass
    graph = RDF::Graph.load("./tests/fixtures/missing_performer.jsonld")
    report =  @shacl.execute(graph)  
    assert report.conform?,"#{report}"
  end

  def test_two_offers_fails
    graph = RDF::Graph.load("./tests/fixtures/two_offers.jsonld")
    report =  @shacl.execute(graph)  
    assert !report.conform?,"#{report}"
  end

  def test_led_zepplin
    graph = RDF::Graph.load("./tests/fixtures/output_led_zepplin.jsonld")
    # pp JSON.parse(graph.dump(:jsonld, standard_prefixes: true))
    report =  @shacl.execute(graph)  
    assert report.conform?,"#{report}"
  end

  def test_facebook_event
    shacl = SHACL.open("./shacl/lavitrine_facebook_shacl.ttl")
    graph = RDF::Graph.load("./tests/fixtures/event_link_facebook.jsonld")
    report =  shacl.execute(graph)  
    assert report.conform?,"#{report}"
  end

  def test_not_facebook_event
    shacl = SHACL.open("./shacl/lavitrine_facebook_shacl.ttl")
    graph = RDF::Graph.load("./tests/fixtures/event_link_bad_facebook.jsonld")
    report =  shacl.execute(graph)  
    assert !report.conform?,"#{report}"
  end

  def test_postal_address_fail
    shacl = SHACL.open("./shacl/lavitrine_postal_address_shacl.ttl")
    graph = RDF::Graph.load("./tests/fixtures/postal_address_2_postal_codes.jsonld")
    report =  shacl.execute(graph)  
    assert !report.conform?,"#{report}"
  end

  def test_missing_artsdata_ids
    shacl = SHACL.open("./shacl/has_artsdata_ids_shacl.ttl")
    graph = RDF::Graph.load("./tests/fixtures/test_events.jsonld")
    report =  shacl.execute(graph)  
    assert !report.conform?,"#{report}"
  end

  def test_place_has_artsdata_ids
    shacl = SHACL.open("./shacl/has_artsdata_ids_shacl.ttl")
    graph = RDF::Graph.load("./tests/fixtures/places_to_test_artsdata_ids.jsonld")
    report =  shacl.execute(graph)  
    assert report.conform?,"#{report}"
  end


end