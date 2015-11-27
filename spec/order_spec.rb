require './lib/order'

describe Order do

  let(:order){Order.new}

  context '#basket' do
    it 'is initialized with an empty basket' do
      expect(order.basket).to be_empty
    end

    it 'raises an error if item is not available' do
      expected_error = 'This item is not available'
      expect{order.add_to_basket('coke', 1)}.to raise_error(expected_error)
    end

    it 'can add item to basket' do
      order.add_to_basket("Cafe Latte", 1)
      expect(order.basket).to include("Cafe Latte")
    end

    it 'can choose quantity of item' do
      order.add_to_basket("Cafe Latte", 2)
      expect(order.basket.count("Cafe Latte")).to eq 2
    end

  end

end
