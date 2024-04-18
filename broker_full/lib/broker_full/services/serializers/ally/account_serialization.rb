require 'json'
require_relative '../../../models/account'
require_relative '../../../models/stock_holding'
require_relative '../json_serializers'

module Serializers
  module Ally
    class AccountSerialization
      include JsonSerializers
      attr_reader :properties

      def initialize(properties)
        @properties = properties
      end

      def to_account(account_response)
        base_account = to_base_object(account_response)
        account_data = account_data_from_base(base_account)
        account_from_data(account_data)
      end

      private

      def account_data_from_base(base_account)
        account_balance = base_account['accountbalance']

        {}.tap do |account|
          account[:account_id]            = account_balance['account']
          account[:cash_available]        = account_balance['buyingpower']['cashavailableforwithdrawal']
          account[:holdings]              = base_account['accountholdings']
          account[:day_trading_available] = account_balance['buyingpower']['daytrading']
          account[:day_trading_sod]       = account_balance['buyingpower']['soddaytrading']
        end
      end

      def account_from_data(account_data)
        cash_available        = account_data[:cash_available] # Cash available
        day_trading_available = account_data[:day_trading_available] # Money available for day trading
        day_trading_sod       = account_data[:day_trading_sod]
        holdings              = holdings_from_account(account_data[:holdings]['holding']) # Hash if single, Arr if multiple
        account_id            = account_data[:account_id]

        Account.new(account_id, cash_available, day_trading_available, day_trading_sod, holdings)
      end

      def holdings_from_account(holdings)
        if holdings.is_a? Array
          return [] if holdings.empty?

          holdings.map do |holding|
            stock_holding_from_data(holding)
          end
        else
          # Single holding (stock)
          [stock_holding_from_data(holdings)]
        end
      end

      def stock_holding_from_data(holding)
        symbol     = holding['instrument']['sym']
        quantity   = holding['qty']
        cost_basis = holding['costbasis']

        StockHolding.new(symbol, quantity, cost_basis)
      end
    end
  end
end
