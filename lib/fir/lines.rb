# frozen_string_literal: true
# encoding: UTF-8

require_relative 'indent'

class Fir
  class Lines
    include Enumerable
    attr_reader :members

    def initialize(*members)
      @members = members
      indent!
    end

    def self.blank
      new([])
    end

    def clone
      self.class.new(*@members.clone.map(&:clone))
    end

    def each(&block)
      @members.each(&block)
    end

    def [](key)
      @members[key]
    end

    def length
      @members.length
    end

    def join(chr = nil)
      map(&:join).join(chr)
    end

    def ==(other)
      other.members == members
    end

    def add(n)
      @members.push(n)
      indent!
    end

    def remove
      return unless @members.length > 1
      @members.pop
      indent!
    end

    def remove_char
      @members[-1]&.pop
      indent!
    end

    def add_char(n)
      @members[-1].push(n)
      indent!
    end

    def blank?
      @members == [[]]
    end

    def executable?
      @executable
    end

    def formatted_lines
      @formatted_lines
    end

    private

    Line = Struct.new(:str, :delta)

    def indent!
      lines = map(&:join)
      indent = Fir::Indent.new(lines).generate
      @executable = indent.executable?
      @formatted_lines = lines.each_with_index.map do |line, i|
        Line.new(line, indent.indents[i])
      end
    end
  end
end
