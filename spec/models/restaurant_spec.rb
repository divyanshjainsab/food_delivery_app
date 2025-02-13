require "rails_helper"

RSpec.describe Restaurant, type: :model do
  it "includes Entryable module" do
    expect(Restaurant.include?(Entryable)).to be true
  end

  describe "associations" do
    it { should have_many :dishes }

    it "has many orders through dishes" do
      # Create a client, an order, and a dish
      client = create :client

      order = create :order, client: client
      # Associate the order with the client through the dish
      client_dishes = client.orders

      # Verify the orders associated with the client
      expect(client_dishes).to include(order)
      expect(order.client).to eq client
    end

    it { should have_many :reviews }
  end

  describe "validations" do
    it "has a Veg category" do
      restaurant = create :restaurant, category: "Veg"
      expect(restaurant.category).to eq("Veg")
      expect(restaurant.Veg?).to be true
      expect(restaurant.Non_Veg?).to be false
    end

    it "has a Non-Veg category" do
      restaurant = create :restaurant, category: "Non-Veg"
      expect(restaurant.category).to eq("Non-Veg")
      expect(restaurant.Veg?).to be false
      expect(restaurant.Non_Veg?).to be true
    end

    it "is invalid without category" do
      restaurant = build :restaurant, category: nil
      expect(restaurant).not_to be_valid
      expect(restaurant.errors[:category]).to include "can't be blank"
    end

    it "stores the correct integer value in the database for Veg" do
      restaurant = create :restaurant, category: "Veg"
      expect(restaurant.category).to eq("Veg")
      expect(restaurant.category_before_type_cast).to eq(0)
    end

    it "stores the correct integer value in the database for Non-Veg" do
      restaurant = create :restaurant, category: "Non-Veg"
      expect(restaurant.category).to eq("Non-Veg")
      expect(restaurant.category_before_type_cast).to eq(1)
    end

    it "is invalid without fssai_licence" do
      restaurant = build :restaurant, fssai_licence: nil
      expect(restaurant).not_to be_valid
      expect(restaurant.errors[:fssai_licence]).to include "can't be blank"
    end

    it "is invalid with any other pattern" do
      restaurant = build :restaurant, fssai_licence: "123/12313"
      expect(restaurant).not_to be_valid
      expect(restaurant.errors[:fssai_licence]).to include "Invalid FASSI Licence"
    end

    it "is valid with specfic patterns" do
      restaurant = build :restaurant, fssai_licence: [ "1001234", "15/1234" ][rand(0 .. 1)]
      expect(restaurant).to be_valid
    end
  end
  describe "default scope" do
    let!(:restaurant) { create(:user,  entryable: create(:restaurant), verified_tag: true) }
    it "selects only the specified columns in the default scope for restaurant" do
      # Using the `default_scope`, retrieve the restaurant record
      restaurant = Restaurant.take

      # Expected selected columns as per `select` in the default scope
      expected_columns = [ :id, :entryable_type, :entryable_id, :email, :phone, :name, :address, :category ]

      # Fetch the attributes that are selected in the query
      selected_attributes = restaurant.attributes.keys.map(&:to_sym)

      # Ensure only the selected columns are included
      expect(selected_attributes).to match_array(expected_columns)
    end
  end
end
