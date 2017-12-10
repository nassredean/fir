# frozen_string_literal: true
# encoding: UTF-8

class Fir
  class Lines
    include Enumerable
    attr_reader :members
    Line = Struct.new(:chars, :delta, :prompt)

    def initialize(*members)
      @members = members
      @lines = members.map do |member|
        Line.new(member, nil, nil)
      end
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
      @members[key].clone
    end

    def []=(key, value)
      @members[key] = value
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
    end

    def remove
      self.class.new(*(@members[0...-1]))
    end

    def blank?
      @members == [[]]
    end

    def lines
      map(&:join)
    end

    def indent!
      indent = Fir::Indent.new(lines).generate
    end
  end
end
