# frozen_string_literal: true
# encoding: UTF-8

class Fir
  class Line
    attr_reader :members
    attr_accessor :delta
    attr_accessor :number
    attr_accessor :prompt

    def initialize(members)
      @members = members
      @delta = 0
      @number = 1
    end

    def ==(other)
      other.members == members
    end

    def length
      members.length
    end

    def to_s
      members.join
    end

    def push(n)
      members.push(n)
    end

    def pop
      members.pop
    end

    def join(chr = nil)
      members.join(chr)
    end
  end
end
