# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra/videoman/version'

Gem::Specification.new do |spec|
  spec.name          = "sinatra-videoman"
  spec.version       = Sinatra::Videoman::VERSION
  spec.authors       = ["Dobromir Ivanov"]
  spec.email         = ["dobromir0ivanov@gmail.com"]
  spec.description   = %q{Sinatra video manager}
  spec.summary       = %q{Sinatra video manager}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

	spec.add_runtime_dependency "sinatra"
  spec.add_runtime_dependency "sinatra-partial"
	spec.add_runtime_dependency "activerecord"
	spec.add_runtime_dependency "protected_attributes"
  spec.add_runtime_dependency "bcrypt-ruby"
  spec.add_runtime_dependency "carrierwave"
end
