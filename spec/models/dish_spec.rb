require "rails_helper"

RSpec.describe Dish, type: :model do
  describe "associations" do
    it "has one attached image" do
      dish = Dish.create!(name: "Test Client", price: 12.2, category: "Veg", description: "present", restaurant: create(:restaurant))

      # Attach an image to the client
      image_file = fixture_file_upload(Rails.root.join("spec", "fixtures", "files", "test_image.jpg"), "image/jpg")
      dish.image.attach(image_file)

      # Check if the image is attached
      expect(dish.image).to be_attached
    end

    it { should belong_to :restaurant }
    it { have_many :orders }
  end

  describe "validations" do
    it "is invalid without a name" do
      dish = Dish.new(price: 12.2, category: "Veg", description: "present", restaurant: create(:restaurant))
      expect(dish).not_to be_valid
      expect(dish.errors[:name]).to include("can't be blank")
    end
  end

  it "is invalid without a price" do
    dish = Dish.new(name: "abc", category: "Veg", description: "present", restaurant: create(:restaurant))
    expect(dish).not_to be_valid
    expect(dish.errors[:price]).to include("can't be blank")
  end

  it "is invalid without a description" do
    dish = Dish.new(price: 12.2, category: "Veg", name: "Meaning ful", restaurant: create(:restaurant))
    expect(dish).not_to be_valid
    expect(dish.errors[:description]).to include("can't be blank")
  end

  it "is invalid without category" do
    dish = build :dish, category: nil
    expect(dish).not_to be_valid
    expect(dish.errors[:category]).to include "can't be blank"
  end

  it "is invalid without a restaurant" do
    dish = Dish.new(name: "abc", price: 12.2, category: "Veg", description: "present")
    expect(dish).not_to be_valid
    expect(dish.errors[:restaurant]).to include("must exist")
  end

  it "is valid with a name, price, description and a restaurant" do
    dish = Dish.new(name: "abc", price: 12.2, category: "Veg", description: "present", restaurant: create(:restaurant))
    expect(dish).to be_valid
  end

  it "is invalid with price 0" do
    dish = Dish.new(name: "abc", price: 0, category: "Veg", description: "present", restaurant: create(:restaurant))
    expect(dish).not_to be_valid
    expect(dish.errors[:price]).to include("must be greater than 0")
  end

  it "has a Veg category" do
    dish = Dish.create(name: "abc", price: 12.2, category: "Veg", description: "present", restaurant: create(:restaurant))
    expect(dish.category).to eq("Veg")
    expect(dish.Veg?).to be true
    expect(dish.Non_Veg?).to be false
  end

  it "has a Non-Veg category" do
    dish = Dish.create(name: "abc", price: 12.2, category: "Non-Veg", description: "present", restaurant: create(:restaurant))
    expect(dish.category).to eq("Non-Veg")
    expect(dish.Veg?).to be false
    expect(dish.Non_Veg?).to be true
  end

  it "stores the correct integer value in the database for Veg" do
    dish = Dish.create(name: "abc", price: 12.2, category: "Veg", description: "present", restaurant: create(:restaurant))
    expect(dish.category).to eq("Veg")
    expect(dish.category_before_type_cast).to eq(0)
  end

  it "stores the correct integer value in the database for Non-Veg" do
    dish = Dish.create(name: "abc", price: 12.2, category: "Non-Veg", description: "present", restaurant: create(:restaurant))
    expect(dish.category).to eq("Non-Veg")
    expect(dish.category_before_type_cast).to eq(1)
  end
end
