require_relative '../utils/calculations'
require_relative 'shared/callable'

module Services
  class AccountService
    include Utils::Calculations, Shared::Callable
    attr_reader :account, :properties

    def initialize(properties)
      @properties = properties
      @account    = refresh
    end

    def refresh
      @account = account_api.info
    end

    def holdings_for(symbol)
      account.holding(symbol)
    end

    def purchasable_shares(price)
      stocks_purchasable(investable_cash, price)
    end

    # Besides account restrictions on buying power, make sure there is not
    # a locally set maximum for investable cash.
    def can_purchase?(price)
      investable_cash > price.to_f
    end

    def shares_owned?(symbol)
      account.shares_owned(symbol).positive?
    end

    def cash_limit_exists?
      investable_cash_limit
    end

    def investable_cash_limit
      return if properties[:maximum_cash_investment].nil? || properties[:maximum_cash_investment].to_s.empty?

      properties[:maximum_cash_investment].to_f
    end

    def investable_cash
      investable_amount = cash_limit_exists? ? investable_cash_limit : account.day_trading_available
      investable_amount - account.invested_amount
    end
  end
end