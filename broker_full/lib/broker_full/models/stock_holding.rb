StockHolding = Struct.new('StockHolding', :symbol, :_quantity, :_cost_basis) do
  def quantity
    return 0 if _quantity.nil? || _quantity.to_s.empty?

    _quantity.to_i
  end

  def cost_basis
    _cost_basis.to_f
  end
end