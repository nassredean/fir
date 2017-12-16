# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/fir/screen_helper'

class DummyClass
end

describe Fir::ScreenHelper do
  before do
    @dummy_class = DummyClass.new
    @dummy_class.extend(Fir::ScreenHelper)
  end

  describe '#previous_line' do
    it 'returns the correct string' do
      @dummy_class.previous_line(1).must_equal("\e[1F")
    end
  end

  describe '#next_line' do
    it 'returns the correct string' do
      @dummy_class.next_line(1).must_equal("\e[1E")
    end
  end

  describe '#horizontal_absolute' do
    it 'returns the correct string' do
      @dummy_class.horizontal_absolute(1).must_equal("\e[1G")
    end
  end

  describe '#clear' do
    it 'returns the correct string' do
      @dummy_class.clear(1).must_equal("\e[1K")
    end
  end
end
