# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby/line'

describe Firby::Line do
  describe '[]=' do
    it 'does not assign' do
      @collection = Firby::Line.new('a')
      @collection[0] = 'b'
      @collection[0].must_equal('a')
    end
  end

  describe 'join' do
    it 'returns empty string when members is blank' do
      @line = Firby::Line.new
      @line.join.must_equal('')
    end

    it 'concats members when not blank' do
      @line = Firby::Line.new('a', 'b', 'c')
      @line.join.must_equal('abc')
    end
  end
end
