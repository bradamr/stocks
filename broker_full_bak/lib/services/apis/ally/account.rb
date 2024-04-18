require_relative '../../shared/restable'
require_relative '../../serializers/account_serialization'

module Apis
  module Ally
    class Account
      include Shared::Restable
      attr_reader :account_s, :properties

      CONTEXT = 'accounts'.freeze
      FORMAT = 'json'.freeze

      def initialize(properties)
        @properties = properties
        @account_s = JsonSerializers::AccountSerialization.new(properties)
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
