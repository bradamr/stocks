require '../../shared/restable'
require '../../serializers/market_serialization'

module Apis
  module Ally
    class Market
      include Shared::Restable
      attr_reader :market_s, :properties

      CONTEXT       = 'market'.freeze
      CLOCK_CONTEXT = 'clock'
      FORMAT        = 'json'.freeze

      def initialize(properties)
        @properties = properties
        @market_s = Serializers::MarketSerialization.new(properties)
      end

      def clock
        request(properties[:sub_contexts]['clock'])
      end

      def quote
        market_s.to_quote(request(properties[:sub_contexts]['quotes'],
                'symbols=' + properties[:stock_symbols]))
      end
    end
  end
end