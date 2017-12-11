# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative 'state_helper'
require_relative './double/output'
require_relative '../lib/fir/renderer'

describe Fir::Renderer do
  describe 'blank state' do
    before do
      @state = Fir::ReplState.blank
      @output = Double::Output.new
      @renderer = Fir::Renderer.new(@output)
    end

    it 'adds prompt' do
      @renderer.perform(@state)
      @output.char_array.must_equal(["[", "1", "]", " "])
    end
  end

  describe 'state with lines and indents' do
    before do
      @state = StateHelper.build(
        [['d', 'e', 'f', ' ', 'c', 'o', 'w'], %w[e n d], ['']],
        [3, 1]
      )
      @output = Double::Output.new
      @renderer = Fir::Renderer.new(@output)
    end

    it 'draws new lines' do
      @renderer.perform(@state)
      # @output.char_array.join.must_equal("def cow\n\e[1Gend\n\e[1G")
    end
  end
end
