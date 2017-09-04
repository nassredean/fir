# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby/indent'
require 'pry'

describe Firby::Indent do

  it 'indents a def statement with a nested if' do
    indenter = Firby::Indent.new(['def cow', 'if true', 'end', 'end'])
    deltas = indenter.indent_lines
    deltas.length.must_equal(4)
    deltas.must_equal([0, 1, 1, 0])
  end

  it 'indents a def statement' do
    indenter = Firby::Indent.new(['def cow',
                                'puts "moo"',
                                'end'])
    deltas = indenter.indent_lines
    deltas.length.must_equal(3)
    deltas.must_equal([0, 1, 0])
  end

  it 'indents a partial def statement' do
    indenter = Firby::Indent.new(['def cow',
                                'puts "moo"'])
    deltas = indenter.indent_lines
    deltas.length.must_equal(2)
    deltas.must_equal([0, 1])
  end

  it 'indents' do
    indenter = Firby::Indent.new(['def cow',
                                'if true',
                                ''])
    deltas = indenter.indent_lines
    deltas.length.must_equal(3)
    deltas.must_equal([0, 1, 2])
  end

  it 'handles while without optional do' do
    indenter = Firby::Indent.new(['while conditional', '1 + 1'])
    deltas = indenter.indent_lines
    deltas.length.must_equal(2)
    deltas.must_equal([0, 1])
  end

  it 'handles while without optional do' do
    indenter = Firby::Indent.new(["while conditional", '1 + 1', 'end'])
    deltas = indenter.indent_lines
    deltas.length.must_equal(3)
    deltas.must_equal([0, 1, 0])
  end

  it 'handles while with optional do' do
    indenter = Firby::Indent.new(["while conditional do", '1 + 1'])
    deltas = indenter.indent_lines
    deltas.length.must_equal(2)
    deltas.must_equal([0, 1])
  end

  it 'handles while with optional do' do
    indenter = Firby::Indent.new(["while conditional do", '1 + 1', ''])
    deltas = indenter.indent_lines
    deltas.length.must_equal(3)
    deltas.must_equal([0, 1, 1])
  end

  it 'handles while with optional do' do
    indenter = Firby::Indent.new(["while conditional do", '1 + 1', 'end'])
    deltas = indenter.indent_lines
    deltas.length.must_equal(3)
    deltas.must_equal([0, 1, 0])
  end

  it 'indents multiline strings' do
    indenter = Firby::Indent.new(['a = "'])
    deltas = indenter.indent_lines
    deltas.length.must_equal(1)
    deltas.must_equal([0])
  end

  it 'handles strings' do
    indenter = Firby::Indent.new(['a = "',
                                ''])
    deltas = indenter.indent_lines
    deltas.length.must_equal(2)
    deltas.must_equal([0, 0])
  end

  it 'handles strings' do
    indenter = Firby::Indent.new(['a = "',
                                'cow"'])
    deltas = indenter.indent_lines
    deltas.length.must_equal(2)
    deltas.must_equal([0, 0])
  end
end
