require_relative 'broker'
require_relative '../services/shared/loggable'
require_relative '../utils/properties'

  class BrokerManager
    include Shared::Loggable
    attr_reader :brokers, :properties, :threads

    def initialize(properties)
      @threads    = []
      @properties = properties #Utils::Properties.load('main.yml')
      @brokers    = @properties[:brokers]
    end

    def begin_trading
      brokers.split(',').each do |b|
        threads << Thread.new do
          create(b).start
        end
      end

      threads.map(&:join)
    end

    private

    def create(broker)
      Broker.new(broker)
    end
  end