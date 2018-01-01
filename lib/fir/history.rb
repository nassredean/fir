# frozen_string_literal: true
# encoding: UTF-8

class Fir
  class History
    attr_reader :counter

    def initialize
      @counter = 0
    end

    def reset
      @counter = 0
    end

    def up
      @counter += 1
    end

    def down
      @counter -= 1 if counter.positive?
    end

    def suggestion(line)
      Fir::Suggestion.new(line, Fir::History.history).generate(counter)
    end

    class << self
      def history_file
        @history_file ||= Fir.config[:history] &&
          File.expand_path(Fir.config[:history])
      end

      def history
        if (history_file && File.exists?(history_file))
          IO.readlines(history_file).map { |e| e.chomp }
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
