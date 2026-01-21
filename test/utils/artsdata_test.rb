require 'minitest/autorun'
require 'linkeddata'

class ArtsdataTest < Minitest::Test
  def test_graph
    g = RDF::Graph.new
    puts g.dump(:jsonld)
  end
  
end