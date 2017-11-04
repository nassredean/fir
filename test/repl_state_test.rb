# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby/repl_state.rb'
require_relative '../lib/firby/lines.rb'
require_relative '../lib/firby/cursor.rb'

describe Firby::ReplState do
  describe 'self.blank' do
    it 'creates a blank collection' do
      @collection = Firby::ReplState.blank
      @collection.lines.must_equal(Firby::Lines.blank)
      @collection.cursor.must_equal(Firby::Cursor.blank)
      @collection.blank?.must_equal(true)
    end
  end

  describe 'self.build' do
    it 'builds lines and cursor from array arguments' do
      @collection = Firby::ReplState.build([[]], [0, 0])
      @collection.lines.must_equal(Firby::Lines.blank)
      @collection.cursor.must_equal(Firby::Cursor.blank)
    end
  end

  describe 'initialization' do
    it 'raises error with no arguments' do
      assert_raises ArgumentError do
        @collection = Firby::ReplState.new
      end
    end

    it 'sets members instance variable correctly with arguments' do
      @collection = Firby::ReplState.new(Firby::Lines.blank, Firby::Cursor.blank)
      @collection.lines.must_equal(Firby::Lines.blank)
      @collection.cursor.must_equal(Firby::Cursor.blank)
      @collection.deltas.must_equal([0])
    end
  end

  describe 'clone' do
    it 'clones the cursor and lines' do
      @collection = Firby::ReplState.blank
      @new_collection = @collection.clone
      @new_collection.lines.must_equal(@collection.lines)
      @new_collection.cursor.must_equal(@collection.cursor)
      @new_collection.object_id.wont_equal(@collection.object_id)
    end
  end

  describe 'blank' do
    it 'creates a new state with blank lines and a blank cursor' do
      @collection = Firby::ReplState.blank
      @new_collection = @collection.blank
      @new_collection.lines.must_equal(Firby::Lines.blank)
      @new_collection.cursor.must_equal(Firby::Cursor.blank)
      @new_collection.object_id.wont_equal(@collection.object_id)
    end
  end

  describe 'clean' do
    it 'returns a blank state if the original state is a block' do
      @collection = Firby::ReplState.build([['d', 'e', 'f', ' ', 'c', 'o', 'w'], ['e', 'n', 'd']], [3, 1])
      @new_collection = @collection.clean
      @new_collection.must_equal(Firby::ReplState.blank)
      @new_collection.object_id.wont_equal(@collection.object_id)
    end
  end

  describe 'transition' do
    it 'returns a new state without modifiying the original' do
      @collection = Firby::ReplState.blank
      @new_collection = @collection.transition do |new_state|
        new_state.lines = Firby::Lines.build([['a']])
      end
      @new_collection.lines.must_equal(Firby::Lines.build([['a']]))
      @new_collection.object_id.wont_equal(@collection.object_id)
    end
  end

  describe 'blank?' do
    it 'returns true when the state has a blank cursor and lines' do
      @collection = Firby::ReplState.blank
      @collection.blank?.must_equal(true)
    end
  end

  describe 'block?' do
    it 'returns true when there is one or more lines that form indent deltas where the last element is 0' do
      @collection = Firby::ReplState.blank
      @collection.block?.must_equal(false)
      @another_collection = Firby::ReplState.build([['d', 'e', 'f', ' ', 'c', 'o', 'w'], ['e', 'n', 'd']], [3, 1])
      @another_collection.block?.must_equal(true)
    end
  end

  describe '==' do
    it 'returns true with two equivalent states' do
      @collection = Firby::ReplState.blank
      @new_collection = Firby::ReplState.blank
      @collection.must_equal(@new_collection)
    end
  end
end
