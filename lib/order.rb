require 'rubygems'
require 'json'
require 'pp'

class Order

  attr_reader :basket, :shop_info

  def initialize
    @basket = []
    @shop_info = JSON.parse(File.read('hipstercoffee.json'))
  end

  def add_to_basket(item, quantity)
    fail 'This item is not available' unless menu.include?(item)
    quantity.times{ @basket << item }
  end

  def menu
    shop_info[0]['prices'][0].keys
  end

end
