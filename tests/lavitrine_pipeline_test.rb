#!/usr/bin/env ruby

require_relative '../src/lavitrine_pipeline'
require 'minitest/autorun'

class PipelineTest < Minitest::Test

  def test_raw_event_priced_offers
    LavitrinePipeline(file: 'tests/fixtures/raw_event_priced_offers.jsonld')
  end

  def test_raw_event_soldout 
    LavitrinePipeline(file: 'tests/fixtures/raw_event_soldout.jsonld')
  end

end

