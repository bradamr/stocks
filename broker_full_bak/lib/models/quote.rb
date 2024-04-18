require 'date'

Quote = Struct.new('Quote', :_symbol, :_price, :_timestamp) do
  def price
    _price.to_f
  end

  def symbol
    _symbol.upcase
  end

  def timestamp
    DateTime.parse(_timestamp)
  end

  def valid?
    !invalid?
  end

  def invalid?
    symbol.nil? || symbol.empty? || _price.nil? || _price.empty?
  end
end