# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nosequel/version'

Gem::Specification.new do |spec|
  spec.name          = "nosequel"
  spec.version       = NoSequel::VERSION
  spec.authors       = ["Donovan C. Young"]
  spec.email         = ["dyoung522@gmail.com"]
  spec.description   = "NoSQL storage methods for Sequel O/RM"
  spec.summary       = "Provides a NoSQL interface class for data storage, backed by Sequel"
  spec.homepage      = "http://github.com/dyoung522/nosequel"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'

  spec.add_dependency 'sequel', '~> 4.1.0'
  spec.add_dependency 'sqlite3' # default storage engine
end
