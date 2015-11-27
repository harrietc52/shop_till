require 'json'

class Order

  TAX = 8.64

  attr_reader :basket, :shop_info

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

  def create_receipt
    File.open("receipts/customer_receipt.txt", "w+") do |file|
      file.write(basket_summary)
    end
  end

  private

  def basket_summary
    basket.uniq.inject(""){ |str, item| str << (item + " #{basket.count(item)} x #{menu[item]}" + "\n") }
  end

end
