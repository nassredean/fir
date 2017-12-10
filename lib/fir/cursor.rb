# frozen_string_literal: true
# encoding: UTF-8

class Fir
  class Cursor
    attr_accessor :x
    attr_accessor :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def self.blank
      new(0, 0)
    end

    def set(x, y)
      @x = x
      @y = y
      self
    end

    def clone
      self.class.new(x, y)
    end

    def up
      set(x, y - 1)
    end

    def down
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
