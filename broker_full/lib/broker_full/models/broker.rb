require_relative 'trader'
require_relative '../services/shared/loggable'

  class Broker
    include Shared::Loggable
    attr_reader :broker_with_mode, :stock_service, :stock_trader

    def initialize(broker_with_mode, properties)
      @broker_with_mode = broker_with_mode
      @properties = properties
      @stock_trader     = Trader.new(properties)
      @stock_service    = StockService.new(properties)

      stock_service.data.add_observer(self)
      logger.info("Broker created: #{broker_with_mode}")
    end

=begin
    def properties
      @properties ||= Utils::Properties.load("brokers/#{trading_mode}/#{broker}.yml")
    end
=end

    def start
      logger.info "Starting stock manager on #{Time.now}..."
      stock_service.start
    end

    def update(symbol)
      stock_trader.decide(stock_service, symbol)
    end

    private

    def broker
      broker_with_mode.split('-').first
    end

    def trading_mode
      broker_with_mode.split('-').last
    end
  end