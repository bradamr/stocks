module Utils
  module Calculations
    def percent_change_from(current, previous)
      current.to_f / previous.to_f
    end

    def stocks_purchasable(cash, stock_price)
      (cash / stock_price).to_i
    end

    def stocks_value(quantity, stock_price)
      (quantity * stock_price).to_f
    end

    def average_price(shares)
      (shares.reduce(:+).to_f / shares.size).to_f
    end
  end
end