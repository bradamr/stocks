require_relative 'lib/broker_full/version'

Gem::Specification.new do |spec|
  spec.name    = "broker_full"
  spec.version = BrokerFull::VERSION
  spec.authors = ["Bradley Mirly"]
  spec.email   = ["brmirly@gmail.com"]

  spec.files = Dir['lib/**/*.rb']
  spec.require_paths = %w(lib)

  spec.summary     = %q{Full Broker library to share in various apps.}
  spec.description = %q{Full Broker library to share in various apps.}

  spec.add_development_dependency 'alpaca-trade-api'
  spec.add_runtime_dependency 'alpaca-trade-api'
end

