require 'nokogiri'

module Serializers
  module Ally
    class OrderSerialization
      # Map object from FIXML object
      def self.from_fixml(fixml)
        xml = Nokogiri::XML(fixml)
        raise 'Implement Me?'
      end

      # Generate FIXML from order object
      def self.to_fixml(order)
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.FIXML(xmlns: 'http://www.fixprotocol.org/FIXML-5-0-SP2') {
            xml.Order(TmInForce: 0, Typ: 1, Side: order.action_code, Acct: order.account_id) {
              xml.Instrmt(SecTyp: 'CS', Sym: order.symbol)
              xml.OrdQty(Qty: order.quantity)
            }
          }
        end

        builder.to_xml
      end
    end
  end
end