BigPurchaseDiscountRule = Struct.new(:price_limit, :discount_percentage) do
  def apply(checkout)
    checkout.products.each { |p| p.price *= percentage } if big_purchase?(checkout)
    checkout
  end

  private

  def percentage
    (100 - discount_percentage) / 100.0
  end

  def big_purchase?(checkout)
    checkout.clean_total > price_limit
  end
end
