require 'deep_clone'

class Checkout
  attr_reader :products

  def initialize(promotion_rules = [])
    @promotion_rules = promotion_rules
    @products = []
  end

  def scan(product)
    @products << product
  end

  def total
    checkout_after_promotion_rules.clean_total
  end

  def clean_total
    @products.map(&:price).reduce(0, &:+).round
  end

  def clone
    DeepClone.clone(self)
  end

  private

  def checkout_after_promotion_rules
    @promotion_rules.reduce(self) { |checkout, rule| rule.apply(checkout.clone) }
  end
end
