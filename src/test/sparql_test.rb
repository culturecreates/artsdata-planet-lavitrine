require 'minitest/autorun'
require 'rdf'
require 'linkeddata'

class SparqlTest < Minitest::Test
  def setup
    @graph = RDF::Graph.load("./fixtures/test_events.jsonld")
  end

  # Removes type: EventForIndex
  def test_that_eventforindex_is_removed
    sparql = "../sparql/remove_eventforindex.sparql"
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    assert_equal 254, graph.count
  end

  def test_transform_single_events
    sparql = "../sparql/transform_single_events.sparql"
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    assert_equal 264, graph.count
  end

  def test_convert_image_object_to_url
    sparql = "../sparql/convert_image_object_to_url.sparql"
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    # puts graph.dump(:turtle)
    assert_equal 240, graph.count
  end

  def test_convert_image_literal_to_uri
    sparql = "../sparql/convert_image_literal_to_uri.sparql"
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    # puts graph.dump(:turtle)
    assert_equal 256, graph.count
  end

  def test_convert_url_literal_to_uri
    sparql = "../sparql/convert_url_literal_to_uri.sparql"
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    # puts graph.dump(:turtle)
    assert_equal 256, graph.count
  end

  def test_convert_offers_to_aggregate_offer
    sparql = "../sparql/convert_offers_to_aggregate_offer.sparql"
    @graph = RDF::Graph.load("./fixtures/two_offers.jsonld")
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    # puts graph.dump(:turtle)
    assert_equal 34, graph.count
  end

  def test_fix_aggreate_offer_url
    sparql = "../sparql/fix_aggregate_offer_url.sparql"
    @graph = RDF::Graph.load("./fixtures/two_offers_multiple_buy_urls.jsonld")
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))

    # puts graph.dump(:turtle)
    query = SPARQL.parse("
      PREFIX schema: <http://schema.org/> 
      ASK { select ?event (count(?url) as ?count)
      where { ?AggregateOffer a schema:AggregateOffer ; schema:url ?url . }	
      group by ?AggregateOffer  having(count(?url) > 1) } 
    ")
    multiple_urls = query.execute(graph)
    assert multiple_urls.false?
  end


end

