require 'em-http'
require 'em-http/middleware/oauth'

module Apis
  module Alpaca
    class StockStreamer
      attr_reader :credentials, :properties, :stock_streaming_uri, :symbols

      def initialize(history, properties)
        @history    = history
        @properties = properties
        @symbols    = properties[:stock_symbols]
        puts "SYMB: #{@symbols}"
        @stock_streaming_uri = full_stock_streaming_uri(properties, @symbols)
        @credentials         = { consumer_key: properties[:consumer_key], consumer_secret: properties[:consumer_secret],
                                 access_token: properties[:oauth_token], access_token_secret: properties[:oauth_token_secret] }.freeze
      end

      def start
        puts "Full URI: #{stock_streaming_uri}"
        EM.run do
          conn = EventMachine::HttpRequest
                     .new(stock_streaming_uri)
          conn.use EventMachine::Middleware::OAuth, credentials
          http = conn.post
          http.stream { |ticker_data| yield ticker_data }
          http.errback { EM.stop }

          trap_events(EM, http)
        end
      end

      private

      def trap_events(em, http)
        trap('INT') do
          http.close
          em.stop
        end

        trap('TERM') do
          http.close
          em.stop
        end
      end

      def full_stock_streaming_uri(properties, symbols)
        properties[:stream_base_uri].to_s + '/' +
            properties[:base_context]['market'].to_s + '/' +
            properties[:sub_contexts]['quotes_stream'].to_s +
            ".json?symbols=#{symbols}"
      end
    end
  end
end