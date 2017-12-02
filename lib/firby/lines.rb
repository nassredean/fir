# frozen_string_literal: true
# encoding: UTF-8

module Firby
  class Lines
    include Enumerable
    attr_reader :members

    def initialize(*members)
      @members = members
    end

    def self.blank
      new([])
    end

    def blank?
      @members == [[]]
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

    def ==(other)
      other.members == members
    end

    def add(n)
      self.class.new(*(@members + [n]))
    end

    def remove
      self.class.new(*(@members[0...-1]))
    end
  end
end
