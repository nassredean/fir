# frozen_string_literal: true
# encoding: UTF-8

require_relative 'collection.rb'

module Firby
  class Lines < Collection
    def self.blank
      new(Line.blank)
    end

    def blank?
      @members == [Line.blank]
    end
  end
end
