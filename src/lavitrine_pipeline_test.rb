require 'minitest/autorun'
require_relative 'lavitrine_pipeline'

class TestLavitrinePipeline < Minitest::Test
  def setup
    @graph = 'http://example.com/graph'
    @artifact = 'example_artifact'
    @pipeline = LavitrinePipeline.new(@graph, @artifact)
  end

  def test_validate
    # Assuming validate method does not return anything
    assert_nil @pipeline.validate(
      "../shacl/lavitrine_event_shacl.ttl",
      "../shacl/lavitrine_offer_shacl.ttl"
    )
  end

  def test_report_artsdata_ids
    # Assuming report_artsdata_ids method does not return anything
    assert_nil @pipeline.report_artsdata_ids("../output/#{@artifact}-missing-artsdata-ids.txt")
  end

  def test_report
    # Assuming report method does not return anything
    assert_nil @pipeline.report("../output/#{@artifact}.yml")
  end

end