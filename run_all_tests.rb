#!/usr/bin/env ruby
# frozen_string_literal: true
# encoding: UTF-8

Dir['test/**/*.rb'].each do |test|
  command = Thread.new do
    system("ruby #{test}")
  end
  status = command.join.value
  raise unless status
end
