# frozen_string_literal: true
# encoding: UTF-8

require_relative 'screen_helper'

class Fir
  class Evaluater
    include ScreenHelper

    attr_reader :output
    attr_reader :error

    def initialize(output, error)
      @output = output
      @error = error
    end

    def perform(state)
      begin
        write_result(eval(state.lines.join("\n"), state.repl_binding, 'fir'))
      rescue Exception => e
        write_error(e)
      ensure
        output.syswrite(prompt(state.cursor.absolute_y))
      end
    end

    private

    def write_result(result)
      output.syswrite(result.inspect)
      output.syswrite(next_line(1))
    end

    def write_error(result)
      error.syswrite(exception_output(result))
      output.syswrite(next_line(1))
    end

    def exception_output(exception)
      "#{exception.class}: #{exception.message}\n    #{backtrace(exception)}"
    end

    def backtrace(exception)
      exception
        .backtrace
        .take_while { |line| line !~ %r{/fir/\S+\.rb} }
        .join("\n    ")
    end
  end
end
