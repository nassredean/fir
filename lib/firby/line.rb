# frozen_string_literal: true
# encoding: UTF-8

require_relative 'collection.rb'

module Firby
  class Line < Collection
    def []=(key, value); end

    def join
      @members.join
    end
  end
end
