# frozen_string_literal: true
# encoding: UTF-8

module Firby
  class Cursor
    def self.origin
      new(0, 0)
    end

    attr_reader :x
    attr_reader :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def clone
      self.class.new(x, y)
    end

    def move(cx, cy)
      self.class.new(cx, cy)
    end

    def up
      move(x, y - 1)
    end

    def down
      move(x, y + 1)
    end

    def left(n)
      move(x - n, y)
    end

    def right(n)
      move(x + n, y)
    end

    def ==(b)
      b.x == x && b.y == y
    end

    def blank?
      x == 0 && y == 0
    end
  end
end
