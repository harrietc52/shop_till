require 'json'

class Order

  TAX = 8.64

  attr_reader :basket, :shop_info, :name, :payment

  def initialize(name)
    @name = name
    @basket = []
    @payment = 0
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

  def pay_bill(amount)
    @payment += amount
    create_receipt
  end

  private

  def receipt_header
    receipt = "#{shop_info[0]["shopName"]}\n\n"
    receipt << "#{shop_info[0]["address"]}\n"
    receipt << "Phone: #{shop_info[0]["phone"]}\n"
    receipt << "#{name}\n"
  end

  def basket_summary
    receipt = receipt_header
    receipt << basket.uniq.inject(""){ |str, item| str << (item + " #{basket.count(item)} x #{menu[item]}" + "\n") }
    receipt << "Tax: #{tax}\n"
    receipt << "Total: £#{subtotal}\n"
    receipt << "Cash: £#{payment}"
  end

end
