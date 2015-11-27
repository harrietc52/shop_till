require './lib/order'

describe Order do

  let(:order){Order.new("Lucy")}

  it "new order is initialized with customers name" do
    expect(order.name).to eq "Lucy"
  end

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

  describe 'receipt' do

    before do
      order.add_to_basket("Cafe Latte", 3)
      order.add_to_basket("Cortado", 2)
    end

    context '#subtotal' do
      it 'calculates total prices of items in the basket' do
        expect(order.subtotal).to eq 23.35
      end
    end

    context '#tax' do
      it 'calculates tax from subtotal' do
        expect(order.tax).to eq 2.02
      end
    end

    context '#create_receipt' do
      it 'shows order summary along with prices, total and tax' do
        expected_content =  "Lucy\n" \
                            "Cafe Latte 3 x 4.75\n" \
                            "Cortado 2 x 4.55\n" \
                            "Tax: 2.02\n" \
                            "Total: £23.35"
        order.create_receipt
        expect(File.read('receipts/customer_receipt.txt')).to include expected_content
      end

      it 'displays details of shop top of receipt' do
        expected_content =  "The Coffee Connection\n\n" \
                            "123 Lakeside Way\n" \
                            "Phone: 16503600708\n"
        order.create_receipt
        expect(File.read('receipts/customer_receipt.txt')).to include expected_content
      end

      it 'takes payment and displays on receipt' do
        order.pay_bill(30)
        expected_content = "Cash: £30"
        expect(File.read('receipts/customer_receipt.txt')).to include expected_content
      end

    end

  end

end
