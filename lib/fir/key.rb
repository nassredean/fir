# frozen_string_literal: true
# encoding: UTF-8

class Fir
  class Key
    attr_reader :input

    def initialize(input)
      @input = input
    end

    def get
      input.raw do |raw_input|
        key = raw_input.sysread(1).chr
        if key == "\e"
          skt = Thread.new { 2.times { key += raw_input.sysread(1).chr } }
          skt.join(0.0001)
          skt.kill
        end
        key
      end
    end
  end
end
