require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = create(:merchant)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)

      @item_order_1 = create(:item_order, quantity: 10)
      @item_order_2 = create(:item_order, quantity: 9)
      @item_order_3 = create(:item_order, quantity: 8)
      @item_order_4 = create(:item_order, quantity: 7)
      @item_order_5 = create(:item_order, quantity: 6)
      @item_order_6 = create(:item_order, quantity: 5)
      @item_order_7 = create(:item_order, quantity: 4)
      @item_order_8 = create(:item_order, quantity: 3)
      @item_order_9 = create(:item_order, quantity: 2)
      @item_order_10 = create(:item_order, quantity: 1)
    end

    it 'most popular items' do
      expected = [@item_order_1.item, @item_order_2.item, @item_order_3.item, @item_order_4.item, @item_order_5.item]
      expect(Item.most_popular_items).to eq(expected)
    end

    it 'least popular items' do
      expected = [@item_order_10.item, @item_order_9.item, @item_order_8.item, @item_order_7.item, @item_order_6.item]
      expect(Item.least_popular_items).to eq(expected)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = create(:order)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end
  end
end
