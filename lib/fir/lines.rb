# frozen_string_literal: true
# encoding: UTF-8

require_relative 'line'
require_relative 'indent'

class Fir
  class Lines
    include Enumerable
    attr_reader :members

    def self.build(*members)
      Lines.new(*members.map { |m| Fir::Line.new(m) })
    end

    def initialize(*members)
      @members = members
    end

    def self.blank
      new(Fir::Line.new([]))
    end

    def clone
      self.class.new(*members.clone.map(&:clone))
    end

    def each(&block)
      members.each(&block)
    end

    def to_r
      if executable?
        self[0...-1]
      else
        self
      end
    end

    def result_prompt
      if executable?
        "\n=> "
      else
        ''
      end
    end

    def [](key)
      members[key]
    end

    def length
      members.length
    end

    def join(chr = nil)
      map(&:join).join(chr)
    end

    def ==(other)
      other.members == members
    end

    def add(n)
      members.push(Fir::Line.new(n))
    end

    def remove
      return unless members.length > 1
      members.pop
    end

    def remove_char
      members[-1]&.pop
    end

    def add_char(n)
      members[-1].push(n)
    end

    def blank!
      @members = [Fir::Line.new([])]
    end

    def blank?
      members == [Fir::Line.new([])]
    end

    def executable?
      @executable
    end

    def indent!(cursor)
      indent = Fir::Indent.new(map(&:join)).generate
      @executable = indent.executable?
      members.last.number = cursor.absolute_y
      each_with_index.map do |line, i|
        line.delta = indent.indents[i]
      end
    end
  end
end
