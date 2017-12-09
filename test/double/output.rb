# frozen_string_literal: true
# encoding: UTF-8

module Double
  class BaseOutput
    attr_reader :char_array

    def initialize
      @char_array = []
    end

    def syswrite(str)
      char_array.push(*str.chars)
    end
  end

  class Output < BaseOutput
  end

  class Error < BaseOutput
  end
end
