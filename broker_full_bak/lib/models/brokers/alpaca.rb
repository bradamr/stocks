require_relative '../broker'

module Brokers
  class Alpaca < Broker
    def initialize(broker)
      super(broker)
    end
  end
end
