# frozen_string_literal: true
# encoding: UTF-8

require 'io/console'

module Firby
  class Repl
    def self.start(input, output)
      with_raw_io(input, output) do |i, o|
        loop do
          CharacterHandlerFactory.build(get_char(i), i, o).call
        end
      end
    end

    def self.with_raw_io(input, output)
      input.raw do |i|
        output.raw do |o|
          yield(i, o)
        end
      end
    end

    def self.get_char(input)
      key = input.sysread(1).chr
      if key == "\e"
        special_key_thread = Thread.new do
          2.times { key += input.sysread(1).chr }
        end
        special_key_thread.join(0.0001)
        special_key_thread.kill
      end
      key
    end
  end
end

class CharacterHandlers
  def self.find(character)
    all.detect { |handler| handler.match?(character) }
  end

  def self.all
    [
      TabHandler,
      EnterHandler,
      BackspaceHandler,
      CtrlCHandler,
      EscapeHandler,
      SingleCharacterHandler
    ]
  end
end

CharacterHandler = Struct.new(:character, :input, :output)

class TabHandler < CharacterHandler
  def self.match?(character)
    false
  end
end

class BackspaceHandler < CharacterHandler
  def self.match?(character)
    false
  end
end

class EnterHandler < CharacterHandler
  def self.match?(character)
    character == "\r"
  end

  def call
    output.syswrite("\n")
  end
end

class EscapeHandler < CharacterHandler
  def self.match?(character)
    false
  end
end

class SingleCharacterHandler < CharacterHandler
  def self.match?(character)
    character.match(/^.$/)
  end

  def call
    output.syswrite(character)
  end
end

class CtrlCHandler < CharacterHandler
  def self.match?(character)
    character == "\u0003"
  end

  def call
    exit(0)
  end
end

class CharacterHandlerFactory
  def self.build(character, input, output)
    CharacterHandlers.find(character).new(character, input, output)
  end
end
