require_relative 'constants'
require_relative 'decision'
require_relative 'order'

require_relative '../services/account_service'
require_relative '../services/shared/callable'
require_relative '../services/shared/loggable'
require_relative '../services/apis/ally/order'

  class Trader
    include Shared::Callable, Shared::Loggable
    attr_reader :account_service, :broker, :properties

    def initialize(properties)
      @properties      = properties
      @broker          = properties[:name]
      @account_service = AccountService.new(properties)
    end

    def decide(stock_service, symbol)
      choice = Decision.make(stock_service.analysis, stock_service.data, account_service, symbol)
      return if choice && choice == Decision::OPTIONS[:hold]

      order = order_from(choice, stock_service.data, symbol, account_service)
      trade(order)
    end

    def trade(order)
      return unless order&.valid?

      logger.info "TRADE :: #{order.description}"
      order_api.send(order) if properties[:trades_enabled].downcase == 'y' # Sends order to Ally
      account_service.refresh
    end

    def order_from(choice, data, symbol, account_service)
      return if choice == Decision::OPTIONS[:hold]

      order_type = order_type_from_choice(choice)
      quantity   = quantity_from_choice(choice, account_service, data, symbol)
      price      = data.latest_price(symbol)

      Order.new(order_type, account_service.account.id, symbol, quantity, price)
    end

    def quantity_from_choice(choice, account_service, stock_analysis, symbol)
      return account_service.purchasable_shares(stock_analysis.latest_price(symbol)) if choice == Decision::OPTIONS[:purchase_max]

      account_service.holdings_for(symbol).quantity if choice == Decision::OPTIONS[:sell_max]
    end

    def order_type_from_choice(choice)
      return Constants::ORDER_ACTIONS[:buy] if choice == Decision::OPTIONS[:purchase_max]

      Constants::ORDER_ACTIONS[:sell] if choice == Decision::OPTIONS[:sell_max]
    end
  end