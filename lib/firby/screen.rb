# frozen_string_literal: true
# encoding: UTF-8

module Firby
  module Screen
    def self.update(state, new_state, output)
      Screen.new(state, new_state, output)
    end

    class Screen
      attr_reader :state
      attr_reader :new_state
      attr_reader :output

      def initialize(state, new_state, output)
        @state = state
        @new_state = new_state
        @output = output
        update_screen
      end

      private

      def update_screen
        erase_screen(state, output)
        draw_screen(new_state, output)
      end

      def erase_screen(state, output)
        unless state.blank?
          state.lines.length.times do |i|
            output.syswrite("#{Cursor.horizontal_absolute(1)}#{Cursor.clear(0)}")
            output.syswrite("#{Cursor.previous_line(1)}#{Cursor.clear(0)}") unless i.zero?
          end
        end
      end

      def draw_screen(state, output)
        output.syswrite(Renderer.new(state).render)
      end

      class Cursor
        def self.forward(n)
          "\e[#{n}C"
        end

        def self.back(n)
          "\e[#{n}D"
        end

        def self.up(n)
          "\e[#{n}A"
        end

        def self.previous_line(n)
          # CSI n F
          # CPL - Cursor Previous Line
          # Moves cursor to beginning of the line n (default 1) lines up
          "\e[#{n}F"
        end

        def self.horizontal_absolute(n)
          # CSI n G
          # CHA - Cursor Horizontal Absolute
          # Moves the cursor to column n (default 1)
          "\e[#{n}G"
        end

        def self.clear(n)
          # CSI n K
          # EL - Erase in Line
          # Erases part of the line.
          # If n is zero (or missing), clear from cursor to the end of the line.
          # If n is one, clear from cursor to beginning of the line.
          # If n is two, clear entire line. Cursor position does not change.
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
end
