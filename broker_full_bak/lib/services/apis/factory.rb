require_relative '../apis/ally/account'
require_relative '../apis/ally/market'
require_relative '../apis/ally/order'

module Apis
  class Factory
    attr_reader :broker, :properties

    def initialize(properties)
      @properties = properties
      @broker     = properties[:name]
    end

    def account
      case broker
      when /ally/
        Api::Ally::Account.new(properties)
      end
    end

    def order
      case broker
      when /ally/
        Api::Ally::Order.new(properties)
      end
    end

    def market
      case broker
      when /ally/
        Api::Ally::Market.new(properties)
      end
    end
  end
end
