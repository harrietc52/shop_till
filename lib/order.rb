class Order

  attr_reader :basket

  def initialize
    @basket = []

  end

  def add_to_basket(item)
    @basket << item
  end

end
