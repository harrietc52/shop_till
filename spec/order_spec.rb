require './lib/order'

describe Order do

  let(:order){Order.new}

  context '#basket' do
    it 'is initialized with an empty basket' do
      expect(order.basket).to be_empty
    end

    it 'can add item to basket' do
      order.add_to_basket("Cafe Latte")
      expect(order.basket).to include("Cafe Latte")
    end

    it 'raises an error if item is not available' do
      expected_error = 'This item is not available'
      expect{order.add_to_basket('coke')}.to raise_error(expected_error)
    end
  end

end
