class Product
  attr_accessor :code, :name, :price

  def initialize(attrs)
    @code = attrs.fetch(:code)
    @name = attrs.fetch(:name)
    @price = attrs.fetch(:price)
  end
end
