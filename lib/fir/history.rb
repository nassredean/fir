# frozen_string_literal: true
# encoding: UTF-8

require_relative '../fir'

class Fir
  class History
    attr_reader :active_selection

    def initialize
      @active_selection = 0
    end

    def reset
      @active_selection = 0
    end

    def up
      @active_selection += 1
    end

    def down
      @active_selection -= 1 if active_selection.positive?
    end

    def suggestion(line)
      Fir::Suggestion.new(
        line,
        Fir::History.history
      ).generate(active_selection)
    end

    class << self
      def history_file
        @history_file ||= Fir.config[:history] &&
          File.expand_path(Fir.config[:history])
      end

      def history
        if (history_file && File.exists?(history_file))
          IO.readlines(history_file).map { |e| e.chomp }
        else
          []
        end
      end

      def add_line_to_history_file(line)
        if history_file
          File.open(history_file, 'a') { |f| f.puts(line) }
        end
      end
    end
  end
end
