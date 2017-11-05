# frozen_string_literal: true
# encoding: UTF-8

require_relative 'collection.rb'
require_relative 'line.rb'

module Firby
  class Lines < Collection
    def self.blank
      new(Line.blank)
    end

    def self.build(members)
      lines = members.map { |m| Firby::Line.build(m) }
      new(*lines)
    end

    def blank?
      @members == [Line.blank]
    end
  end
end
