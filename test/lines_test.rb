# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby/lines'
require_relative '../lib/firby/line'

describe Firby::Lines do
  describe 'self.blank' do
    it 'creates a blank collection' do
      @collection = Firby::Lines.blank
      @collection.members.must_equal([Firby::Line.blank])
      @collection.blank?.must_equal(true)
    end
  end

  describe 'blank?' do
    it 'when members is blank is true' do
      @collection = Firby::Lines.blank
      @collection.blank?.must_equal(true)
    end

    it 'when members has elements blank is false' do
      @collection = Firby::Lines.new(Firby::Line.new('a', 'b', 'c'))
      @collection.blank?.must_equal(false)
    end
  end
end
