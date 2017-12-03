# frozen_string_literal: true
# encoding: UTF-8

module Fir
  class Screen
    attr_reader :state
    attr_reader :new_state
    attr_reader :output
    attr_reader :error
    attr_reader :repl_binding
    attr_reader :line_number

    def initialize(output, error)
      @output = output
      @error = error
      @repl_binding = TOPLEVEL_BINDING
      @line_number = 1
    end

    def update(state, new_state)
      erase_screen(state)
      draw_screen(new_state)
      evaluate(new_state)
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
      output.syswrite(state
        .indents
        .map { |delta| '  ' * delta }
        .zip(state.lines.map(&:join))
        .map(&:join)
        .join("\n#{Cursor.horizontal_absolute(1)}"))
    end

    def evaluate(state)
      return unless state.executable?
      begin
        result = eval(state.lines.join("\n"), repl_binding, 'fir', line_number)
      rescue Exception => e
        result = e
      ensure
        # write the result to output
        if result.class < Exception
          stack = result.backtrace.take_while { |line| line !~ %r{/fir/\S+\.rb} }
          error.syswrite("#{result.class}: #{result.message}\n    #{stack.join("\n    ")}")
        else
          output.syswrite(result.inspect)
        end
        # move the cursor down one line
        output.syswrite(Cursor.next_line(1))
      end
    end


    class Cursor
      # this should be a CursorHelpers module
      def self.previous_line(n)
        "\e[#{n}F"
      end

      def self.horizontal_absolute(n)
        "\e[#{n}G"
      end

      def self.clear(n)
        "\e[#{n}K"
      end

      def self.next_line(n)
        "\e[#{n}E"
      end
    end
  end
end
