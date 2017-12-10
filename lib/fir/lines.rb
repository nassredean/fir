# frozen_string_literal: true
# encoding: UTF-8

class Fir
  class Lines
    include Enumerable
    attr_reader :members

    def initialize(*members)
      @members = members
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
    end

    def remove
      @members.pop
    end

    def remove_char
      @members[-1]&.pop
    end

    def add_char(n)
      @members[-1].push(n)
    end

    def blank?
      @members == [[]]
    end

    def indent!
      indent = Fir::Indent.new(map(&:join)).generate
    end
  end
end
