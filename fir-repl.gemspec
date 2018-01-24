# frozen_string_literal: true

require File.expand_path('../lib/fir/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'fir-repl'
  s.version       = Fir::VERSION
  s.date          = '2017-07-18'
  s.summary       = 'A Ruby REPL inspired by the Fish shell'
  s.description   = s.summary
  s.authors       = ['Nassredean Nasseri']
  s.email         = 'dean@nasseri.io'
  s.homepage      = 'https://github.com/dnasseri/fir'
  s.files         = `git ls-files bin lib *.md LICENSE`.split("\n")
  s.executables   = ['fir']
  s.require_paths = ['lib']
  s.license       = 'MIT'
  s.required_ruby_version = '>= 2.3.0'
end
