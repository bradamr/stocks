require_relative '../../shared/restable'
require_relative '../../serializers/order_serialization'

module Apis
  module Ally
    class Order
      include Shared::Restable
      attr_reader :properties

      CONTEXT = 'accounts'.freeze
      FORMAT  = 'xml'.freeze

      def initialize(properties)
        @properties = properties
      end

      def send(order)
        order_fixml = Serializers::OrderSerialization.to_fixml(order)
        submit(order_fixml, account_id_with_orders)
      end

      private

      def account_id_with_orders
        properties[:account_id].to_s + '/orders'
      end
    end
  end
end