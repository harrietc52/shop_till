require 'rubygems'
require 'json'

class Order

  attr_reader :basket, :shop_info

  TAX = 8.64

  def initialize
    @basket = []
    @shop_info = JSON.parse(File.read('hipstercoffee.json'))
  end

  def add_to_basket(item, quantity)
    fail 'This item is not available' unless menu.keys.include?(item)
    quantity.times{ @basket << item }
  end

  def menu
    shop_info[0]['prices'][0]
  end

  def subtotal
    basket.inject(0){ |tot, item| tot += menu[item] }
  end

  def tax
    (subtotal/100*TAX).round(2)
  end

end
