require_relative '../../shared/restable'

module Apis
  module Alpaca
    class Account
      include Shared::Restable
      attr_reader :account_s, :properties

      CONTEXT = 'accounts'.freeze
      FORMAT = 'json'.freeze

      def initialize(properties)
        @properties = properties
      end

      def all
        request
      end

      def info
        response = request('/' + properties[:account_id].to_s)
        account_s.to_account(response)
      end

      def balances
        request('balances')
      end
    end
  end
end
