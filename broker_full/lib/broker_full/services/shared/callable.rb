require 'broker_full/services/apis/factory'

module Shared
  module Callable
    def properties
      raise 'Implement me.'
    end

    def api_factory
      @api_factory ||= Api::Factory.new(properties)
    end

    def account_api
      @account_api ||= api_factory.account
    end

    def market_api
      @market_api ||= api_factory.market
    end

    def order_api
      @order_api ||= api_factory.order
    end
  end
end