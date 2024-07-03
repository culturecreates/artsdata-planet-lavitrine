require 'minitest/autorun'
require 'linkeddata'

class SparqlTest < Minitest::Test
  def setup
    @graph = RDF::Graph.load("./tests/fixtures/test_events.jsonld")
  end

  # Removes type: EventForIndex
  def test_that_eventforindex_is_removed
    sparql = "./src/sparql/remove_eventforindex.sparql"
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    assert_equal 254, graph.count
  end

  def test_transform_single_events
    sparql = "./src/sparql/transform_single_events.sparql"
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    assert_equal 264, graph.count
  end

  def test_convert_image_object_to_url
    sparql = "./src/sparql/convert_image_object_to_url.sparql"
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    # puts graph.dump(:turtle)
    assert_equal 240, graph.count
  end

  def test_convert_image_literal_to_uri
    sparql = "./src/sparql/convert_image_literal_to_uri.sparql"
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    # puts graph.dump(:turtle)
    assert_equal 256, graph.count
  end

  def test_convert_url_literal_to_uri
    sparql = "./src/sparql/convert_url_literal_to_uri.sparql"
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    # puts graph.dump(:turtle)
    assert_equal 256, graph.count
  end

  def test_convert_offers_to_aggregate_offer
    sparql = "./src/sparql/convert_offers_to_aggregate_offer.sparql"
    @graph = RDF::Graph.load("./tests/fixtures/two_offers.jsonld")
   # puts @graph.dump(:turtle)
    @graph.query(SPARQL.parse(File.read(sparql), update: true))
    # puts @graph.dump(:jsonld)
    assert_equal "8.0", @graph.query([nil, RDF::Vocab::SCHEMA.lowPrice, nil]).first.object.to_s
    assert_equal "20.0", @graph.query([nil, RDF::Vocab::SCHEMA.highPrice, nil]).first.object.to_s
    assert_equal 1, @graph.query([RDF::URI("https://www.grandtheatre.qc.ca/programmation/midis-musique-25-octobre-2023-2023-10-25-16-10#SingleEvent_WrappedOffer"), RDF.type, RDF::Vocab::SCHEMA.AggregateOffer]).count
    assert_equal 5, @graph.query([RDF::URI("https://www.grandtheatre.qc.ca/programmation/midis-musique-25-octobre-2023-2023-10-25-16-10#SingleEvent_WrappedOffer"), RDF::Vocab::SCHEMA.offers, nil]).count
  end

  # Ensure only one AggregateOffer is created for an event
  def test_fix_aggreate_offer_url
    sparql = "./src/sparql/fix_aggregate_offer_url.sparql"
    @graph = RDF::Graph.load("./tests/fixtures/two_offers_multiple_buy_urls.jsonld")
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

  def test_fix_aggregatte_offer_url_no_url
    sparql = "./src/sparql/fix_aggregate_offers_missing_url.sparql"
    @graph = RDF::Graph.load("./tests/fixtures/event_missing_aggregate_offer_url.jsonld")
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    ## puts graph.dump(:turtle)
    assert_equal 'http://first_event.com', graph.query([RDF::URI("http://first_offer.com"),RDF::Vocab::SCHEMA.url, nil]).first.object.to_s
    assert_equal 'http://event.url.com', graph.query([RDF::URI("http://second_offer.com"),RDF::Vocab::SCHEMA.url, nil]).first.object.to_s
    assert_equal 'http://offer.url.com', graph.query([RDF::URI("http://third_offer.com"),RDF::Vocab::SCHEMA.url, nil]).first.object.to_s
    assert_equal 'http://offer.url.com', graph.query([RDF::URI("http://fourth_offer.com"),RDF::Vocab::SCHEMA.url, nil]).first.object.to_s
 
  end


  def test_remove_temporary_eventtype
    sparql = "./src/sparql/remove_temporary_eventtype.sparql"
    @graph = RDF::Graph.load("./tests/fixtures/event_with_additional_types.jsonld")
    graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
    # puts graph.dump(:turtle)
    assert_equal 5, graph.count
  end


  def test_offers_footlight_aggregate_offer_removed
    sparql = "./src/sparql/remove_footlight_aggregate_offer.sparql"
    @graph = RDF::Graph.load("./tests/fixtures/offers_footlight_aggregate_offer.jsonld")
    # puts @graph.dump(:turtle)
    @graph.query(SPARQL.parse(File.read(sparql), update: true))
    # puts @graph.dump(:turtle)
    assert_equal 10, @graph.count
  end


  def test_offers_footlight_aggregate_offer_kept
    sparql = "./src/sparql/remove_footlight_aggregate_offer.sparql"
    @graph = RDF::Graph.load("./tests/fixtures/offers_footlight_aggregate_offer_keep.jsonld")
    # puts @graph.dump(:turtle)
    @graph.query(SPARQL.parse(File.read(sparql), update: true))
    # puts @graph.dump(:turtle)
    assert_equal 6, @graph.count
  end


  def test_fix_aggregate_offers_missing_url
    sparql = "./src/sparql/fix_aggregate_offers_missing_url.sparql"
    @graph = RDF::Graph.load("./tests/fixtures/aggregate_offers_missing_url.jsonld")
    # puts "BEFORE: #{@graph.dump(:turtle)}"
    @graph.query(SPARQL.parse(File.read(sparql), update: true))
    # puts "AFTER: #{@graph.dump(:turtle)}"
    assert_equal 22, @graph.count
  end

end

