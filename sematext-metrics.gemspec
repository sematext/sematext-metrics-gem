# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sematext/metrics/version'

Gem::Specification.new do |spec|
  spec.name          = "sematext-metrics"
  spec.version       = Sematext::Metrics::VERSION
  spec.authors       = ["Pavel Zalunin"]
  spec.email         = ["info@sematext.com"]
  spec.description   = %q{Gem for talking to SPM}
  spec.summary       = %q{Gem for sending custom metrics to SPM}
  spec.homepage      = "http://github.com/sematext/sematext-metrics-gem"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 2.13.0"
  spec.add_development_dependency "rake"
  
  spec.add_runtime_dependency "httparty", "~> 0.11.0"
end
