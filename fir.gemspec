# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name          = 'fir'
  s.version       = '0.1.0'
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
