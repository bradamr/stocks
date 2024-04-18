require_relative 'constants'

Order = Struct.new('Order', :_action, :_account_id, :symbol, :quantity, :price) do
  def account_id
    _account_id.to_i
  end

  def description
    "[Account ID: #{account_id}] #{buy? ? 'Bought' : 'Sold'} #{quantity} shares of [#{symbol.upcase}] @ $#{price}"
  end

  def action_code
    _action
  end

  def buy?
    _action == Constants::ORDER_ACTIONS[:buy]
  end

  def sell?
    action_code == Constants::ORDER_ACTIONS[:sell]
  end

  def valid?
    _action =~ /^(#{Constants::ORDER_ACTIONS[:buy]}|#{Constants::ORDER_ACTIONS[:sell]})$/ &&
        _account_id =~ /^\w+$/ && symbol =~ /^\w+$/ &&
        quantity.is_a?(Integer) && price.is_a?(Float)
  end
end