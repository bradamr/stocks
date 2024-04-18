require_relative 'account'
require_relative '../utils/calculations'

module Models
  Account = Struct.new('Account', :id, :_cash_available, :_day_trading_available, :_day_trading_start_of_day, :_holdings) do
    include Utils::Calculations

    def cash_available
      _cash_available.to_f
    end

    def day_trading_available
      _day_trading_available.to_f
    end

    def invested_amount
      return 0 unless _holdings && _holdings.size > 0

      _holdings.map { |holding| holding.cost_basis }.reduce(:+)
    end

    def day_trading_start_of_day
      _day_trading_start_of_day.to_f
    end

    def holding(symbol)
      return unless _holdings
      _holdings.select { |h| h.symbol.downcase == symbol.downcase }.first
    end

    def shares_owned(symbol)
      holding = holding(symbol)
      return 0 if holding.nil?

      holding.quantity
    end

    def balance(symbol, price)
      cash_available + (shares_owned(symbol) * price)
    end
  end
end