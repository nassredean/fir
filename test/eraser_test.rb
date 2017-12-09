# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative 'state_helper'
require_relative './double/output'
require_relative '../lib/fir/eraser'

describe Fir::Eraser do
  describe 'blank state' do
    before do
      @state = Fir::ReplState.blank
      @output = Double::Output.new
      @eraser = Fir::Eraser.new(@output)
    end

    it 'does not add any special characters' do
      @eraser.perform(@state)
      @output.char_array.must_equal([])
    end
  end

  describe 'state with lines and indents' do
    before do
      @state = StateHelper.build(
        [['d', 'e', 'f', ' ', 'c', 'o', 'w'], %w[e n d], ['']],
        [3, 1]
      )
      @output = Double::Output.new
      @eraser = Fir::Eraser.new(@output)
    end

    it 'erases previous lines' do
      @eraser.perform(@state)
      @output.char_array.join.must_equal(
        "\e[1G\e[0K\e[1G\e[0K\e[1F\e[0K\e[1G\e[0K\e[1F\e[0K"
      )
    end
  end
end
