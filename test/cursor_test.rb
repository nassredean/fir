# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby/cursor'

describe Firby::Cursor do
  describe 'self.blank' do
    it 'creates a blank collection' do
      @collection = Firby::Cursor.blank
      @collection.blank?.must_equal(true)
    end
  end

  describe 'initialization' do
    it 'raises argument errror when set with no arguments' do
      assert_raises ArgumentError do
        @collection = Firby::Cursor.new
      end
    end

    it 'sets x and y' do
      @collection = Firby::Cursor.new(1, 1)
      @collection.x.must_equal(1)
      @collection.y.must_equal(1)
    end
  end

  describe 'clone' do
    it 'initializes a new cursor with same x and y' do
      @collection = Firby::Cursor.new(1, 1)
      @new_collection = @collection.clone
      @new_collection.x.must_equal(1)
      @new_collection.y.must_equal(1)
    end
  end

  describe 'up' do
    it 'initializes a new cursor with x=1 and y=2 without' do
      @collection = Firby::Cursor.new(1, 1)
      @new_collection = @collection.up
      @new_collection.x.must_equal(1)
      @new_collection.y.must_equal(0)
    end
  end

  describe 'down' do
    it 'initializes a new cursor with x=1 and y=0' do
      @collection = Firby::Cursor.new(1, 1)
      @new_collection = @collection.down
      @new_collection.x.must_equal(1)
      @new_collection.y.must_equal(2)
    end
  end

  describe 'left' do
    it 'initializes a new cursor with same x and y' do
      @collection = Firby::Cursor.new(1, 1)
      @new_collection = @collection.clone
      @new_collection.x.must_equal(1)
      @new_collection.y.must_equal(1)
    end
  end

  describe 'right' do
    it 'initializes a new cursor with same x and y' do
      @collection = Firby::Cursor.new(1, 1)
      @new_collection = @collection.right(1)
      @new_collection.x.must_equal(2)
      @new_collection.y.must_equal(1)
    end
  end

  describe '==' do
    it 'initializes a new cursor with same x and y' do
      @collection = Firby::Cursor.new(1, 1)
      @other_collection = @collection.clone
      @other_collection.must_equal(@collection)
    end
  end

  describe 'blank?' do
    it 'initializes a new cursor with same x and y' do
      @collection = Firby::Cursor.blank
      @collection.blank?.must_equal(true)
    end
  end
end
