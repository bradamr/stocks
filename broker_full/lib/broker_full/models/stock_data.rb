require 'observer'
require_relative '../utils/calculations'
require_relative '../services/shared/loggable'
require_relative 'stock_analysis'

  class StockData
    include Utils::Calculations, Shared::Loggable, Observable
    attr_reader :minimum_trends, :prices, :properties, :trends

    def initialize(properties)
      @properties     = properties
      @minimum_trends = properties[:minimum_trends]
      @prices         = {}
      @trends         = {}
    end

    def prices_count(symbol)
      hash_by_symbol_count(prices, symbol)
    end

    def trends_count(symbol)
      hash_by_symbol_count(trends, symbol)
    end

    def hash_by_symbol_count(hash, symbol)
      return 0 if hash[symbol].nil?

      hash[symbol].count
    end

    def initialize_prices_and_trends(symbol)
      prices[symbol] = []
      trends[symbol] = []
    end

    def no_data?(symbol)
      prices[symbol].nil? || trends[symbol].nil?
    end

    def add(quote)
      return if quote.invalid? || duplicate_of_latest?(quote)

      contain_sizes(quote)
      append_trend_and_price(quote)
      update_observers(quote)
    end

    def can_use_trends?(symbol)
      trends_count(symbol).positive?
    end

    def duplicate_of_latest?(quote)
      quote.price == latest_price(quote.symbol) if prices_count(quote.symbol).positive?
    end

    def purge_data(symbol)
      @prices[symbol] = @prices[symbol].last(minimum_trends + 1)
      @trends[symbol] = @trends[symbol].last(minimum_trends + 1)
    end

    def latest_price(symbol)
      prices[symbol]&.last
    end

    def latest_trend(symbol)
      trends[symbol]&.last
    end

    def previous_price(symbol)
      prices[symbol][-2]
    end

    private

    def update_observers(quote)
      changed
      notify_observers(quote.symbol)
    end

    # Initialize trends/quotes if non-existent, otherwise purge data if overgrown
    def contain_sizes(quote)
      symbol = quote.symbol
      purge_data(symbol) if prices_count(symbol) > minimum_trends * 10
      initialize_prices_and_trends(symbol) if no_data?(symbol)
    end

    def append_trend_and_price(quote)
      symbol = quote.symbol
      prices[symbol] << quote.price
      trends[symbol] << change_from_previous(quote) if prices_count(symbol) > 1
    end

    def change_from_previous(quote)
      return 0 unless prices_count(quote.symbol) > 1

      percent_change_from(quote.price, previous_price(quote.symbol))
    end
  end