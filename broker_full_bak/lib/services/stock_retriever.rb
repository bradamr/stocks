require 'observer'
require_relative 'shared/callable'
require_relative 'shared/loggable'
require_relative 'apis/ally/market'
require_relative 'serializers/market_serialization'

module Services
  class StockRetriever
    include Shared::Callable, Shared::Loggable
    attr_reader :data, :properties

    def initialize(data, properties)
      @properties = properties
      @data       = data
    end

    def start
      loop do
        begin
          quotes = market_api.quote
          next unless quotes.is_a? Array

          quotes.each { |quote| data.add(quote) if quote.valid? } # Add ticker data if valid
          sleep sleep_delay
        rescue StandardError => e
          logger.error 'Error caught from retrieving quotes:', e
        end
      end
    end

    private

    def sleep_delay
      properties[:delays]['quotes'].to_i
    end
  end
end