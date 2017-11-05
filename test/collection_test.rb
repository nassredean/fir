# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby/collection'

describe Firby::Collection do
  describe 'self.blank' do
    it 'creates a blank collection' do
      @collection = Firby::Collection.blank
      @collection.members.must_equal([])
      @collection.blank?.must_equal(true)
    end
  end

  describe 'initialization' do
    it 'sets members instance variable correctly with no arguments' do
      @collection = Firby::Collection.new
      @collection.members.must_equal([])
    end

    it 'sets members instance variable correctly with arguments' do
      @collection = Firby::Collection.new('a', 'b')
      @collection.members.must_equal(%w[a b])
    end
  end

  describe 'clone' do
    it 'clones correctly with no members' do
      @collection = Firby::Collection.new
      @new_collection = @collection.clone
      @new_collection.members.must_equal([])
    end

    it 'clones correctly with members' do
      @collection = Firby::Collection.new('a', 'b', 'c')
      @new_collection = @collection.clone
      @new_collection.members.must_equal(%w[a b c])
    end
  end

  describe '[]' do
    it 'calling a non existant member is nil' do
      @collection = Firby::Collection.blank
      @collection[0].must_equal(nil)
    end

    it 'calling an existant member is the correct value' do
      @collection = Firby::Collection.new('a', 'b')
      @collection[0].must_equal('a')
      @collection[1].must_equal('b')
      @collection[-1].must_equal('b')
    end
  end

  describe '[]=' do
    it 'assigns correctly' do
      @collection = Firby::Collection.new('a')
      @collection[0] = 'b'
      @collection[0].must_equal('b')
    end
  end

  describe 'length' do
    it 'when members is blank length is zero' do
      @collection = Firby::Collection.new
      @collection.length.must_equal(0)
    end

    it 'when members has elements length is correct' do
      @collection = Firby::Collection.new('a', 'b', 'c')
      @collection.length.must_equal(3)
    end
  end

  describe '==' do
    it 'compares two empty collections' do
      @collection_a = Firby::Collection.new
      @collection_b = Firby::Collection.new
      (@collection_a == @collection_b).must_equal(true)
    end

    it 'compares two collections that are equal and returns true' do
      @collection_a = Firby::Collection.new('a', 'b')
      @collection_b = Firby::Collection.new('a', 'b')
      (@collection_a == @collection_b).must_equal(true)
    end

    it 'compares two collections that are not equal and returns false' do
      @collection_a = Firby::Collection.new
      @collection_b = Firby::Collection.new('a')
      (@collection_a == @collection_b).must_equal(false)
    end
  end

  describe 'blank?' do
    it 'when members is blank is true' do
      @collection = Firby::Collection.new
      @collection.blank?.must_equal(true)
    end

    it 'when members has elements blank is false' do
      @collection = Firby::Collection.new('a', 'b', 'c')
      @collection.blank?.must_equal(false)
    end
  end

  describe 'add' do
    it 'adds correctly without members, and does not modify original state' do
      @collection = Firby::Collection.new
      @new_collection = @collection.add('a')
      @collection.members.must_equal([])
      @new_collection.members.must_equal(['a'])
    end

    it 'adds correctly with members, and does not modify original state' do
      @collection = Firby::Collection.new('a', 'b', 'c')
      @new_collection = @collection.add('d')
      @collection.members.must_equal(%w[a b c])
      @new_collection.members.must_equal(%w[a b c d])
    end
  end

  describe 'remove' do
    it 'removes correctly without members, and does not modify original state' do
      @collection = Firby::Collection.new
      @new_collection = @collection.remove
      @collection.members.must_equal([])
      @new_collection.members.must_equal([])
    end

    it 'adds correctly with members, and does not modify original state' do
      @collection = Firby::Collection.new('a', 'b', 'c')
      @new_collection = @collection.remove
      @collection.members.must_equal(%w[a b c])
      @new_collection.members.must_equal(%w[a b])
    end
  end
end
