# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby/cursor'

describe Firby::Cursor do
  describe 'self.blank' do
    it 'creates a blank collection' do
      @collection = Firby::Cursor.blank
      @collection.members.must_equal([0, 0])
      @collection.blank?.must_equal(true)
    end
  end

  describe 'self.build' do
    it 'builds a new cursor from an array of length two' do
      @collection = Firby::Cursor.build([0, 0])
      @collection.members.must_equal([0, 0])
      @collection.x.must_equal(0)
      @collection.y.must_equal(0)
    end
  end

  describe 'initialization' do
    it 'raises argument errror when set with no arguments' do
      assert_raises ArgumentError do
        @collection = Firby::Cursor.new
      end
    end

    it 'sets members instance variable correctly with arguments' do
      @collection = Firby::Cursor.new(1, 1)
      @collection.members.must_equal([1, 1])
      @collection.x.must_equal(1)
      @collection.y.must_equal(1)
    end
  end

  describe 'clone' do
    it 'initializes a new cursor with same x and y without modifying original' do
      @collection = Firby::Cursor.new(1, 1)
      @new_collection = @collection.clone
      @new_collection.members.must_equal([1, 1])
      @new_collection.x.must_equal(1)
      @new_collection.y.must_equal(1)
      @new_collection.object_id.wont_equal(@collection.object_id)
    end
  end

  describe 'up' do
    it 'initializes a new cursor with x=1 and y=2 without modifying original' do
      @collection = Firby::Cursor.new(1, 1)
      @new_collection = @collection.up
      @new_collection.members.must_equal([1, 0])
      @new_collection.x.must_equal(1)
      @new_collection.y.must_equal(0)
      @new_collection.object_id.wont_equal(@collection.object_id)
    end
  end

  describe 'down' do
    it 'initializes a new cursor with x=1 and y=0 without modifying original' do
      @collection = Firby::Cursor.new(1, 1)
      @new_collection = @collection.down
      @new_collection.members.must_equal([1, 2])
      @new_collection.x.must_equal(1)
      @new_collection.y.must_equal(2)
      @new_collection.object_id.wont_equal(@collection.object_id)
    end
  end

  describe 'left' do
    it 'initializes a new cursor with same x and y without modifying original' do
      @collection = Firby::Cursor.new(1, 1)
      @new_collection = @collection.clone
      @new_collection.members.must_equal([1, 1])
      @new_collection.x.must_equal(1)
      @new_collection.y.must_equal(1)
      @new_collection.object_id.wont_equal(@collection.object_id)
    end
  end

  describe 'right' do
    it 'initializes a new cursor with same x and y without modifying original' do
      @collection = Firby::Cursor.new(1, 1)
      @new_collection = @collection.right(1)
      @new_collection.members.must_equal([2, 1])
      @new_collection.x.must_equal(2)
      @new_collection.y.must_equal(1)
      @new_collection.object_id.wont_equal(@collection.object_id)
    end
  end

  describe '==' do
    it 'initializes a new cursor with same x and y without modifying original' do
      @collection = Firby::Cursor.new(1, 1)
      @other_collection = @collection.clone
      @other_collection.must_equal(@collection)
    end
  end

  describe 'blank?' do
    it 'initializes a new cursor with same x and y without modifying original' do
      @collection = Firby::Cursor.blank
      @collection.blank?.must_equal(true)
    end
  end
end
