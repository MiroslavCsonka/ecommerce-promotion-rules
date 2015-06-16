OverQuantityPromotionRule = Struct.new(:product_code, :quantity, :new_price) do
  def apply(checkout)
    products = checkout.products.select { |p| p.code == product_code }
    if products.length >= quantity
      products.each { |p| p.price = new_price }
    end
    checkout
  end
end
