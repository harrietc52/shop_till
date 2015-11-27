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

  def discount_over_50
    (subtotal*(0.05)).round(2) if subtotal > 50
  end

  def discount_of_muffin
    basket.inject(0) { |tot, item | item.include?("Muffin") ? (tot += (menu[item]*(0.1)).round(2)) : tot }
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
    receipt << "Total: £#{subtotal.round(2)}\n"
    receipt << "Cash: £#{payment}\n"
    receipt << "Change: £#{(payment - subtotal).round(2)}"
  end

end
