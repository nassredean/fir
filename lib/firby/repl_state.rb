# frozen_string_literal: true
# encoding: UTF-8

module Firby
  class ReplState
    class Cursor
      def self.origin
        Cursor.new(0, 0)
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
    end

    def self.new_state
      new([[]], Cursor.origin)
    end

    attr_accessor :lines
    attr_accessor :cursor

    def initialize(lines, cursor)
      @lines = lines
      @cursor = cursor
    end

    def clone
      self.class.new(lines.dup, cursor.clone)
    end
  end
end
