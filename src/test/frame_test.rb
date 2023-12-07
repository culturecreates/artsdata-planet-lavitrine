require 'minitest/autorun'
require 'linkeddata'

class FrameTest < Minitest::Test
  def setup
    @frame = JSON.parse(File.read('../../frame/lavitrine_event_frame.jsonld'))
   
  end

  def test_loading_frame_should_pass
    input = JSON.parse(File.read('./fixtures/full_event.jsonld'))
    framed_json = JSON::LD::API.frame(input, @frame)
    assert framed_json
  end

  def test_nested_offers_does_not_contain_bad
    input = JSON.parse(File.read('./fixtures/event_offers.jsonld'))
    framed_json = JSON::LD::API.frame(input, @frame)
    # pp framed_json
    assert !framed_json["representation"][0]["offers"]["offers"]["bad"]
  end




end