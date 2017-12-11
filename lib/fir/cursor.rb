# frozen_string_literal: true
# encoding: UTF-8

class Fir
  class Cursor
    attr_reader :x
    attr_reader :y
    attr_reader :absolute_y

    def initialize(**opts)
      @x = opts[:x]
      @y = opts[:y]
      @absolute_y = opts[:absolute_y] || 1
    end

    def self.blank
      new(x: 0, y: 0)
    end

    def set(x, y)
      @x = x
      @y = y
      self
    end

    def clone
      self.class.new(x: x, y: y, absolute_y: absolute_y)
    end

    def up
      @absolute_y -= 1
      set(x, y - 1)
    end

    def down
      @absolute_y += 1
      set(x, y + 1)
    end

    def left(n)
      set(x - n, y)
    end

    def right(n)
      set(x + n, y)
    end

    def ==(other)
      other.x == x && other.y == y
    end

    def blank?
      x.zero? && y.zero?
    end
  end
end
