$VERBOSE = nil  # Suppress Ruby warnings

require 'minitest/autorun'
require 'linkeddata'

class FrameTest < Minitest::Test
  def setup
    @frame = JSON.parse(File.read('./frame/lavitrine_event_frame.jsonld'))
   
  end

  def test_loading_frame_should_pass
    input = JSON.parse(File.read('./test/fixtures/full_event.jsonld'))
    framed_json = JSON::LD::API.frame(input, @frame)
    assert framed_json
    expected = "EventSeries"
    assert_equal expected, framed_json["type"]
  end

  def test_top_level_organizer_removed
    input = JSON.parse(File.read('./test/fixtures/full_event.jsonld'))
    framed_json = JSON::LD::API.frame(input, @frame)
    assert  !framed_json["organizer"]
  end

  def test_nested_offers_does_not_contain_bad
    input = JSON.parse(File.read('./test/fixtures/event_offers.jsonld'))
    framed_json = JSON::LD::API.frame(input, @frame)
    # pp framed_json
    assert !framed_json["representation"][0]["offers"]["offers"]["bad"]
  end

  def test_exposition_frame
    frame = JSON.parse(File.read('./frame/lavitrine_exposition_frame.jsonld'))
    input = JSON.parse(File.read('./test/fixtures/expositions.jsonld'))
    options = {:omitGraph => false}
    framed_json = JSON::LD::API.frame(input, frame, **options)
    # pp framed_json
    assert framed_json["@graph"].class == Array
  end


end