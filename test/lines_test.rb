# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/fir/lines'

describe Fir::Lines do
  describe 'self.blank' do
    it 'creates a blank lines' do
      @lines = Fir::Lines.blank
      @lines.members.must_equal([[]])
      @lines.blank?.must_equal(true)
    end
  end

  describe 'blank?' do
    it 'when members is blank is true' do
      @lines = Fir::Lines.blank
      @lines.blank?.must_equal(true)
    end

    it 'when members has elements blank is false' do
      @lines = Fir::Lines.new(%w[a b c])
      @lines.blank?.must_equal(false)
    end
  end

  describe 'clone' do
    it 'clones correctly with no members' do
      @lines = Fir::Lines.blank
      @new_lines = @lines.clone
      @new_lines.members.must_equal([[]])
    end

    it 'clones correctly with members' do
      @lines = Fir::Lines.new(['a'], ['b'], ['c'])
      @new_lines = @lines.clone
      @new_lines.members.must_equal([['a'], ['b'], ['c']])
    end
  end

  describe '[]' do
    it 'calling a non existant member is nil' do
      @lines = Fir::Lines.blank
      @lines[0].must_equal([])
    end

    it 'calling an existant member is the correct value' do
      @lines = Fir::Lines.new(['a'], ['b'])
      @lines[0].must_equal(['a'])
      @lines[1].must_equal(['b'])
      @lines[-1].must_equal(['b'])
    end
  end

  describe 'length' do
    it 'blank line length is 1' do
      @lines = Fir::Lines.blank
      @lines.length.must_equal(1)
    end

    it 'when members has elements length is correct' do
      @lines = Fir::Lines.new(['a'], ['b'], ['c'])
      @lines.length.must_equal(3)
    end
  end

  describe '==' do
    it 'compares two empty liness' do
      @lines_a = Fir::Lines.blank
      @lines_b = Fir::Lines.blank
      (@lines_a == @lines_b).must_equal(true)
    end

    it 'compares two liness that are equal and returns true' do
      @lines_a = Fir::Lines.new(['a'], ['b'])
      @lines_b = Fir::Lines.new(['a'], ['b'])
      (@lines_a == @lines_b).must_equal(true)
    end

    it 'compares two liness that are not equal and returns false' do
      @lines_a = Fir::Lines.blank
      @lines_b = Fir::Lines.new(['a'])
      (@lines_a == @lines_b).must_equal(false)
    end
  end

  describe 'add' do
    it 'adds a new array and indents' do
      @lines = Fir::Lines.blank
      @lines.add(['a'])
      @lines.members.must_equal([[], ['a']])
      @lines.formatted_lines.first.str.must_equal('')
      @lines.formatted_lines.first.delta.must_equal(0)
      @lines.formatted_lines[-1].str.must_equal('a')
      @lines.formatted_lines[-1].delta.must_equal(0)
    end
  end

  describe 'remove' do
    it 'removes correctly without members' do
      @lines = Fir::Lines.blank
      @lines.remove
      @lines.members.must_equal([[]])
    end

    it 'adds correctly with members' do
      @lines = Fir::Lines.new(%w[a b c], %w[d])
      @lines.remove
      @lines.members.must_equal([%w[a b c]])
    end
  end
end
