# frozen_string_literal: true
# encoding: UTF-8

require_relative 'lines.rb'
require_relative 'cursor.rb'
require_relative 'indent.rb'
require_relative 'collection.rb'

module Firby
  class ReplState < Collection
    attr_accessor :lines
    attr_accessor :cursor
    attr_reader :deltas

    def self.blank
      new(Lines.blank, Cursor.blank)
    end

    def self.build(lines, cursor)
      new(Lines.build(lines), Cursor.build(cursor))
    end

    def initialize(lines, cursor)
      @lines = lines
      @cursor = cursor
      @members = [lines, cursor]
      set_indent
    end

    def transition
      b = clone
      yield b
      b.set_indent
      b
    end

    def clone
      self.class.new(lines.clone, cursor.clone)
    end

    def blank
      self.class.new(Lines.blank, Cursor.blank)
    end

    def clean
      return blank if block?
      self
    end

    def blank?
      @members.all?(&:blank?)
    end

    def block?
      deltas.length > 1 && deltas[-1].zero?
    end

    def ==(other)
      members == other.members
    end

    protected

    def set_indent
      @deltas = compute_indent
    end

    private

    def compute_indent
      Firby::Indent.new(lines.map(&:join)).indent_lines
    end
  end
end
