# frozen_string_literal: true
# encoding: UTF-8

require_relative 'line.rb'
require_relative 'lines.rb'
require_relative 'cursor.rb'

module Firby
  class ReplState
    attr_accessor :lines
    attr_accessor :cursor
    attr_reader :deltas

    def self.blank
      new(Lines.blank, Cursor.origin)
    end

    def initialize(lines, cursor)
      @lines = lines
      @cursor = cursor
      @deltas = compute_indent
    end

    def transition
      b = self.clone
      yield b
      b
    end

    def clone
      self.class.new(lines.clone, cursor.clone)
    end

    def blank
      self.class.new(Lines.blank, Cursor.origin)
    end

    def cleanse
      return blank if block?
      self
    end

    def blank?
      lines.blank? && cursor.blank?
    end

    def block?
      deltas.length > 1 && deltas[-1].zero?
    end

    def ==(b)
      b.cursor == cursor && b.lines == lines
    end

    private

    def compute_indent
      Firby::Indent.new(lines.map(&:join)).indent_lines
    end
  end
end
