require_relative '../spec_helper'
require_relative '../../libs/checkout'
require_relative '../../libs/product'
require_relative '../../libs/promotion_rules/big_purchase_discount_rule'
require_relative '../../libs/promotion_rules/over_quantity_promotion_rule'

describe Checkout do
  # Usually I would have FactoryGirl factories for this
  # can not use let(:sym){} because of its memoization feature
  def product_one
    Product.new(code: 1, name: 'Travel Card Holder', price: 925)
  end

  def product_two
    Product.new(code: 2, name: 'Personalised cufflinks', price: 4500)
  end

  def product_three
    Product.new(code: 3, name: 'Kids T-shirt', price: 1995)
  end

  # Again I would use FactoryGirl for these roles, so there wouldn't be problem with 'magic numbers'
  let(:big_purchase_rule) { BigPurchaseDiscountRule.new(6000, 10) }
  let(:over_quantity_rule) { OverQuantityPromotionRule.new(1, 2, 850) }

  describe 'price calculations' do
    it 'without promotion rules' do
      checkout = Checkout.new
      checkout.scan(product_one)
      checkout.scan(product_two)
      checkout.scan(product_three)

      expect(checkout.total).to eq 7420
    end

    it 'with big purchase discount' do
      checkout = Checkout.new([big_purchase_rule])
      checkout.scan(product_one)
      checkout.scan(product_two)
      checkout.scan(product_three)

      expect(checkout.total).to eq 6678
    end

    it 'with over quantity limit promotion' do
      checkout = Checkout.new([over_quantity_rule])
      checkout.scan(product_one)
      checkout.scan(product_three)
      checkout.scan(product_one)

      expect(checkout.total).to eq 3695
    end

    it 'big purchase and over quantity limit' do
      rules = [over_quantity_rule, big_purchase_rule]
      checkout = Checkout.new(rules)
      checkout.scan(product_one)
      checkout.scan(product_two)
      checkout.scan(product_one)
      checkout.scan(product_three)

      expect(checkout.total).to eq 7376
    end
  end
end
