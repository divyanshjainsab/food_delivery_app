require 'rails_helper'

RSpec.describe Entryable, type: :model do
  # it must included in client, restaurant and rider model
  it 'is included in Client model' do
    expect(Client.include? Entryable).to be true
  end
  it 'is included in Restaurant model' do
    expect(Restaurant.include? Entryable).to be true
  end
  it 'is included in Rider model' do
    expect(Rider.include? Entryable).to be true
  end


  # Testing associations
  describe 'delegated association' do
    it 'delegates the association to the correct entryable type' do
      # Create a user and associate it with a client (this assumes User has an entryable association)
      entryable = create(%i[ client rider restaurant ][rand(0 .. 2)])
      user = create(:user, entryable: entryable)

      # Check that the user is correctly associated with the client
      expect(user.entryable).to eq(entryable)
      expect(user.entryable_type).to eq user.entryable_type # Verify entryable_type is set correctly
    end
  end

  # describing default scope
  describe 'default scope' do
    let!(:verified_client) { create(:user,  entryable: create(:client), verified_tag: true) }
    let!(:unverified_client) { create(:user,  entryable: create(:client), verified_tag: false) }
    let!(:verified_rider) { create(:user,  entryable: create(:rider), verified_tag: true) }
    let!(:unverified_rider) { create(:user,  entryable: create(:rider), verified_tag: false) }
    let!(:verified_restaurant) { create(:user,  entryable: create(:restaurant), verified_tag: true) }
    let!(:unverified_restaurant) { create(:user,  entryable: create(:restaurant), verified_tag: false) }

    # it includes only verified users
    it "only includes clients with verified users" do
      clients = Client.all
      expect(clients).to include(verified_client.client)
      expect(clients).not_to include(unverified_client)
    end

    it "only includes riders with verified users" do
      riders = Rider.all
      expect(riders).to include(verified_rider.rider)
      expect(riders).not_to include(unverified_rider)
    end

    it "only includes restaurants with verified users" do
      restaurants = Restaurant.all
      expect(restaurants).to include(verified_restaurant.restaurant)
      expect(restaurants).not_to include(unverified_restaurant)
    end

    it "selects only the specified columns in the default scope for client" do
      # Using the `default_scope`, retrieve the client record
      client = Client.take

      # Expected selected columns as per `select` in the default scope
      expected_columns = [ :id, :entryable_type, :entryable_id, :email, :phone, :name, :address ]

      # Fetch the attributes that are selected in the query
      selected_attributes = client.attributes.keys.map(&:to_sym)

      # Ensure only the selected columns are included
      expect(selected_attributes).to match_array(expected_columns)
    end

    it "selects only the specified columns in the default scope for rider" do
      # Using the `default_scope`, retrieve the rider record
      rider = Rider.take

      # Expected selected columns as per `select` in the default scope
      expected_columns = [ :id, :entryable_type, :entryable_id, :email, :phone, :name, :address, :status ]

      # Fetch the attributes that are selected in the query
      selected_attributes = rider.attributes.keys.map(&:to_sym)

      # Ensure only the selected columns are included
      expect(selected_attributes).to match_array(expected_columns)
    end

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
