Gem::Specification.new do |spec|
  spec.author                = 'XWPS L.L.C.'
  spec.name                  = 'broker_full'
  spec.version               = '0.0.1'
  spec.date                  = %q(2020-01-18)
  spec.summary               = %q(full suite of broker interaction)
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = Gem::Requirement.new('>= 2.1.0')
  spec.files                 = Dir["**/*"]
  spec.require_paths         = %w(lib)

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_development_dependency 'json'
  spec.add_development_dependency 'oauth'
  spec.add_development_dependency 'em-http-request'
  spec.add_development_dependency 'alpaca-trade-api'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'httparty'
  spec.add_development_dependency 'simple_oauth'
  spec.add_development_dependency 'nokogiri'
  spec.add_development_dependency 'eventmachine'
  spec.add_development_dependency 'api_struct'
end
