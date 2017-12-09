# frozen_string_literal: true
# encoding: UTF-8

require_relative 'cursor_helper'

module Fir
  class Evaluater
    include CursorHelper

    attr_reader :output
    attr_reader :error

    def initialize(output, error)
      @output = output
      @error = error
    end

    def perform(state)
      return unless state.executable?
      begin
        result = eval(state.lines.join("\n"), state.repl_binding, 'fir')
      rescue Exception => e
        result = e
      ensure
        write_result(result)
      end
    end

    private

    def write_result(result)
      if result.class < Exception
        error.syswrite(exception_output(result))
      else
        output.syswrite(result.inspect)
      end
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
