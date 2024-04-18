require 'json'
require_relative '../../../models/clock'
require_relative '../../../models/quote'
require_relative '../json_serializers'

module Serializers
  module Ally
    class MarketSerialization
      include JsonSerializers
      attr_reader :properties

      def initialize(properties)
        @properties = properties
      end

      def to_clock(clock_response)
        base_clock = to_base_object(clock_response)['status']
        change_at  = base_clock['change_at']
        current    = base_clock['current']
        next_at    = base_clock['next_at']

        Clock.new(change_at, current, next_at)
      end

      def to_quote(quote_response)
        return nil if quote_response.nil? || quote_response.empty?

        base_quotes = to_base_object(quote_response)['quotes']['quote']
        return [quote_from_data(base_quotes)] unless base_quotes.is_a? Array

        base_quotes.map do |base_quote|
          quote_from_data(base_quote)
        end
      end

      private

      def quote_from_data(base_quote)
        ask                         = base_quote[properties[:quote_keys]['ask']]
        bid                         = base_quote[properties[:quote_keys]['bid']]
        datetime                    = base_quote[properties[:quote_keys]['datetime']]
        price                       = base_quote[properties[:quote_keys]['price']]
        symbol                      = base_quote[properties[:quote_keys]['symbol']]
        open                        = base_quote[properties[:quote_keys]['open']]
        change_from_prior           = base_quote[properties[:quote_keys]['change_from_prior']]
        change_from_prior_direction = base_quote[properties[:quote_keys]['change_from_prior_direction']]
        prior_close                 = base_quote[properties[:quote_keys]['prior_close']]
        Quote.new(symbol, open, prior_close, price, ask, bid, change_from_prior, change_from_prior_direction, datetime)
      end
    end
  end
end

module XmlSerializers
  module Ally
    # This will be used mainly by StockStreamer
    class MarketSerialization
      def self.to_quote(quote_response)
        # Use Nokogiri to do stuff and convert
      end
    end
  end
end