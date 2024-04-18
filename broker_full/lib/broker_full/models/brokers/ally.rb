require_relative '../broker'

module Brokers
  class Ally < Broker
    def initialize(broker)
      super(broker)
    end
  end
end
