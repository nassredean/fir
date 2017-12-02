# frozen_string_literal: true
# encoding: UTF-8

module Firby
  class Cursor
    attr_reader :x
    attr_reader :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def self.blank
      new(0, 0)
    end

    def clone
      self.class.new(x, y)
    end

    def up
      self.class.new(x, y - 1)
    end

    def down
      self.class.new(x, y + 1)
    end

    def left(n)
      self.class.new(x - n, y)
    end

    def right(n)
      self.class.new(x + n, y)
    end

    def ==(other)
      other.x == x && other.y == y
    end

    def blank?
      x.zero? && y.zero?
    end
  end
end
