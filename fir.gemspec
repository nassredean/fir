# frozen_string_literal: true
require File.expand_path('../lib/fir/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'fir'
  s.version       = Fir::VERSION
  s.date          = '2017-07-18'
  s.summary       = 'A Ruby REPL inspired by the Fish shell'
  s.description   = s.summary
  s.authors       = ['Nassredean Nasseri']
  s.email         = 'dean@nasseri.io'
  s.files         = `git ls-files bin lib *.md LICENSE`.split("\n")
  s.executables   = ['fir']
  s.require_paths = ['lib']
  s.license       = 'MIT'
end
