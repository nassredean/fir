# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/fir/lines'

describe Fir::Lines do
  describe 'self.blank' do
    it 'creates a blank lines' do
      @lines = Fir::Lines.blank
      @lines.members.must_equal([Fir::Line.new([])])
      @lines.blank?.must_equal(true)
    end
  end

  describe 'blank?' do
    it 'when members is blank is true' do
      @lines = Fir::Lines.blank
      @lines.blank?.must_equal(true)
    end

    it 'when members has elements blank is false' do
      @lines = Fir::Lines.build(%w[a b c])
      @lines.blank?.must_equal(false)
    end
  end

  describe 'clone' do
    it 'clones correctly with no members' do
      @lines = Fir::Lines.blank
      @new_lines = @lines.clone
      @new_lines.must_equal(@lines)
    end

    it 'clones correctly with members' do
      @lines = Fir::Lines.build(['a'], ['b'], ['c'])
      @new_lines = @lines.clone
      @new_lines.must_equal(@lines)
    end
  end

  describe '[]' do
    it 'calling an existant member is the correct value' do
      @lines = Fir::Lines.build(['a'], ['b'])
      @lines[0].must_equal(Fir::Line.new(['a']))
      @lines[1].must_equal(Fir::Line.new(['b']))
      @lines[-1].must_equal(Fir::Line.new(['b']))
    end
  end

  describe 'length' do
    it 'blank line length is 1' do
      @lines = Fir::Lines.blank
      @lines.length.must_equal(1)
    end

    it 'when members has elements length is correct' do
      @lines = Fir::Lines.build(['a'], ['b'], ['c'])
      @lines.length.must_equal(3)
    end
  end

  describe '==' do
    it 'compares two empty liness' do
      @lines_a = Fir::Lines.blank
      @lines_b = Fir::Lines.blank
      @lines_a.must_equal(@lines_b)
    end

    it 'compares two liness that are equal and returns true' do
      @lines_a = Fir::Lines.build(['a'], ['b'])
      @lines_b = Fir::Lines.build(['a'], ['b'])
      @lines_a.must_equal(@lines_b)
    end

    it 'compares two liness that are not equal and returns false' do
      @lines_a = Fir::Lines.blank
      @lines_b = Fir::Lines.build(['a'])
      (@lines_a == @lines_b).must_equal(false)
    end
  end

  describe 'add' do
    it 'adds a new array and indents' do
      @lines = Fir::Lines.blank
      @lines.add(['a'])
      @lines.must_equal(Fir::Lines.build([], ['a']))
      @lines.first.to_s.must_equal('')
      @lines.first.delta.must_equal(0)
      @lines[-1].to_s.must_equal('a')
      @lines[-1].delta.must_equal(0)
    end
  end

  describe 'remove' do
    it 'removes correctly without members' do
      @lines = Fir::Lines.blank
      @lines.remove
      @lines.must_equal(Fir::Lines.build([]))
    end

    it 'adds correctly with members' do
      @lines = Fir::Lines.build(%w[a b c], %w[d])
      @lines.remove
      @lines.must_equal(Fir::Lines.build(%w[a b c]))
    end
  end
end
