require_relative '../utils/calculations'
require_relative 'quote'
require_relative 'stock_data'

  class StockAnalysis
    include Utils::Calculations
    attr_reader :data, :minimum_trends, :negative_threshold, :positive_threshold, :properties

    TREND_TYPES = {
        # Price is trending upward
        positive: :positive,
        # Price is trending downward
        negative: :negative,
        # When price is fluctuating near similar values
        neutral: :neutral,
        # Not used a lot but for when insufficient data
        unknown: :unknown
    }.freeze

    def initialize(stock_data, properties)
      @data               = stock_data
      @properties         = properties
      @minimum_trends     = properties[:minimum_trends]
      @positive_threshold = properties[:thresholds]['positive'].to_f
      @negative_threshold = properties[:thresholds]['negative'].to_f
    end

    def latest_price_increased?(symbol)
      return false if data.prices_count(symbol) < 2

      data.latest_price(symbol) > data.previous_price(symbol)
    end

    def latest_price_decreased?(symbol)
      return false if data.prices_count(symbol) < 2

      data.latest_price(symbol) < data.previous_price(symbol)
    end

    def trending_positive?(symbol)
      return TREND_TYPES[:unknown] if data.trends_count(symbol) < minimum_trends

      recent_trend(symbol) >= positive_threshold
    end

    def trending_negative?(symbol)
      return TREND_TYPES[:unknown] if data.trends_count(symbol) < minimum_trends

      recent_trend(symbol) <= negative_threshold
    end

    def trending_neutral?(symbol)
      return TREND_TYPES[:unknown] if data.trends_count(symbol) < minimum_trends

      recent_trend(symbol) > negative_threshold &&
          recent_trend(symbol) < positive_threshold
    end


    def trend_unknown?(symbol)
      data.trends_count(symbol) < minimum_trends
    end

    def price_and_trend_increase?(symbol)
      trending_positive?(symbol) && latest_price_increased?(symbol)
    end

    def price_and_trend_decrease?(symbol)
      trending_negative?(symbol) && latest_price_decreased?(symbol)
    end

    def recent_trend(symbol)
      return TREND_TYPES[:unknown] if data.trends_count(symbol) < minimum_trends

      data.trends[symbol].last(minimum_trends).reduce(:+) / minimum_trends
    end
  end