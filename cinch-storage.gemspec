# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cinch/extensions/storage/version'

Gem::Specification.new do |spec|
  spec.name          = "cinch-storage"
  spec.version       = Cinch::Extensions::Storage::VERSION
  spec.authors       = ["Donovan C. Young"]
  spec.email         = ["dyoung522@gmail.com"]
  spec.description   = "Persistent data storage for Cinch"
  spec.summary       = "Provides a persistant data storage engine for the Cinch IRC framework"
  spec.homepage      = "http://github.com/dyoung522/cinch-storage"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'sqlite3'

  spec.add_dependency 'cinch', '~> 2.0.7'
  spec.add_dependency 'sequel', '~> 4.1.0'
end
