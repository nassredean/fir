# frozen_string_literal: true
# encoding: UTF-8

module Fir
  class Screen
    attr_reader :state
    attr_reader :new_state
    attr_reader :output

    def initialize(output)
      @output = output
    end

    def update(state, new_state)
      erase_screen(state)
      draw_screen(new_state)
    end

    private

    def erase_screen(state)
      return if state.blank?
      state.lines.length.times do |i|
        output.syswrite("#{Cursor.horizontal_absolute(1)}#{Cursor.clear(0)}")
        unless i.zero?
          output.syswrite("#{Cursor.previous_line(1)}#{Cursor.clear(0)}")
        end
      end
    end

    def draw_screen(state)
      output.syswrite(Renderer.new(state).render)
    end

    class Cursor
      def self.previous_line(n)
        "\e[#{n}F"
      end

      def self.horizontal_absolute(n)
        "\e[#{n}G"
      end

      def self.clear(n)
        "\e[#{n}K"
      end
    end

    class Renderer
      attr_reader :state

      def initialize(state)
        @state = state
      end

      def render
        indents
          .zip(state.lines.map(&:join))
          .map(&:join)
          .join("\n#{Cursor.horizontal_absolute(1)}")
      end

      private

      def indents
        @indents ||= state.deltas.map { |d| '  ' * d }
      end
    end
  end
end
