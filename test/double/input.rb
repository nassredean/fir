# frozen_string_literal: true
# encoding: UTF-8

module Double
  class Input
    attr_reader :char_array

    def initialize(char_array)
      @char_array = char_array
    end

    def raw
      yield RawInput.new(char_array) if block_given?
    end

    class RawInput
      attr_reader :char_array

      def initialize(char_array)
        @char_array = char_array
        @counter = 0
      end

      def sysread(_)
        char = char_array[@counter]
        return '' unless char
        @counter += 1
        char
      end
    end
  end
end
