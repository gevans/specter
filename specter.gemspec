# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'specter/version'

Gem::Specification.new do |spec|
  spec.name          = 'specter'
  spec.version       = Specter::VERSION
  spec.authors       = ['Gabe Evans']
  spec.email         = ['gabe@ga.be']
  spec.summary       = %q{Specter stubs a subset of the cgminer client protocol. It allows you to test your programs against a dummy server when writing programs that interact with cgminer and cgminer-compatibile software.}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/gevans/specter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_dependency 'expedition'
  spec.add_dependency 'middleware'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
end
