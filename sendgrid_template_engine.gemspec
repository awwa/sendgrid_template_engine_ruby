# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sendgrid_template_engine/version'

Gem::Specification.new do |spec|
  spec.name          = "sendgrid_template_engine"
  spec.version       = SendgridTemplateEngine::VERSION
  spec.authors       = ["awwa500@gmail.com"]
  spec.email         = ["awwa500@gmail.com"]
  spec.summary       = "SendGrid Template Engine API module"
  spec.description   = "SendGrid Template Engine API module"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "dotenv"
end
