# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'passwords' do
    it 'is valid with a password and password_confirmation' do
      user = build :user, password: 'password123', password_confirmation: 'password123', entryable: build(:client)
      expect(user).to be_valid
    end

    it 'is invalid if password and password_confirmation do not match' do
      user = build :user, password: 'password123', password_confirmation: 'wrongpassword', entryable: build(:client)
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it 'is invalid without a password' do
      user = build :user, password: nil, password_confirmation: nil, entryable: build(:client)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'authenticates with correct password' do
      user = create :user, password: 'password123', password_confirmation: 'password123', entryable: build(:client)
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      user = create :user, password: 'password123', password_confirmation: 'password123', entryable: build(:client)
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end

  describe "delegated type" do
    describe 'associations' do
      it 'can belong to a restaurant' do
        restaurant = build :restaurant
        user = create :user, entryable: restaurant
        expect(user.entryable).to eq restaurant
        expect(restaurant.user).to eq user
      end

      it 'can belong to a rider' do
        rider = build :rider
        user = create :user, entryable: rider
        expect(user.entryable).to eq rider
        expect(rider.user).to eq user
      end

      it 'can belong to a client' do
        client = build :client
        user = create :user, entryable: client
        expect(user.entryable).to eq client
        expect(client.user).to eq user
      end
    end

    describe 'dependent: :destroy' do
      it 'destroys associated restaurant when a user is destroyed' do
        restaurant = Restaurant.create category: 0, fssai_licence: "1001232424"
        user = User.create entryable: restaurant, email: Faker::Internet.email, password: "password", password_confirmation: "password", phone: "+91-1223123212", address: Faker::Address.street_address.ljust(24), name: Faker::Name.name, verified_tag: true

        # Destroy the user and check that the restaurant is also destroyed
        expect { user.destroy }.to change { Restaurant.all.size }.by(-1)
      end

      it 'destroys associated rider when a user is destroyed' do
        rider = Rider.create status: 0, driving_licence: "DL-12-2345-123456", vehical_number: "DL-12-NC-1232", date_of_birth: 18.years.ago
        user = User.create entryable: rider, email: Faker::Internet.email, password: "password", password_confirmation: "password", phone: "+91-1223123212", address: Faker::Address.street_address.ljust(24), name: Faker::Name.name, verified_tag: true

        # Destroy the user and check that the rider is also destroyed
        expect { user.destroy }.to change { Rider.all.size }.by(-1)
      end

      it 'destroys associated client when a user is destroyed' do
        client = Client.create
        user = User.create entryable: client, email: Faker::Internet.email, password: "password", password_confirmation: "password", phone: "+91-1223123212", address: Faker::Address.street_address.ljust(24), name: Faker::Name.name, verified_tag: true

        # Destroy the user and check that the client is also destroyed
        expect { user.destroy }.to change { Client.all.size }.by(-1)
      end
    end
  end

  it { should have_one :misc }

  describe 'validations' do
    context 'when creating a new user' do
      it 'is valid with a name, email, phone, password, password_confirmation, address and an Entryable' do
        user = User.new(
          name: 'Test User',
          email: 'test@example.com',
          phone: '1234567890',
          password: 'password123',
          password_confirmation: 'password123',
          address: '123 Main St',
          entryable: Client.new
        )
        expect(user).to be_valid
      end

      it 'is invalid without a name' do
        user = User.new(
          name: nil,
          email: 'test@example.com',
          phone: '1234567890',
          password: 'password123',
          password_confirmation: 'password123',
          address: '123 Main St',
          entryable: Client.new
        )
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("can't be blank")
      end

      it 'is invalid without an email' do
        user = User.new(
          name: 'Test User',
          email: nil,
          phone: '1234567890',
          password: 'password123',
          password_confirmation: 'password123',
          address: '123 Main St',
          entryable: Client.new
        )
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'is invalid without a phone' do
        user = User.new(
          name: 'Test User',
          email: 'test@example.com',
          phone: nil,
          password: 'password123',
          password_confirmation: 'password123',
          address: '123 Main St',
          entryable: Client.new
        )
        expect(user).not_to be_valid
        expect(user.errors[:phone]).to include("can't be blank")
      end

      it 'is invalid without an address' do
        user = User.new(
          name: 'Test User',
          email: 'test@example.com',
          phone: '1234567890',
          password: 'password123',
          password_confirmation: 'password123',
          address: nil,
          entryable: Client.new
        )
        expect(user).not_to be_valid
        expect(user.errors[:address]).to include("can't be blank")
      end

      it 'is invalid if password and password_confirmation do not match' do
        user = User.new(
          name: 'Test User',
          email: 'test@example.com',
          phone: '1234567890',
          password: 'password123',
          password_confirmation: 'differentpassword',
          address: '123 Main St',
          entryable: Client.new
        )
        expect(user).not_to be_valid
        expect(user.errors[:password_confirmation]).to include("doesn't match Password")
      end

      it 'is invalid if password is less than 8 characters' do
        user = User.new(
          name: 'Test User',
          email: 'test@example.com',
          phone: '1234567890',
          password: 'short',
          password_confirmation: 'short',
          address: '123 Main St',
          entryable: Client.new
        )
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('is too short (minimum is 8 characters)')
      end

      it 'is valid if password is at least 8 characters long' do
        user = User.new(
          name: 'Test User',
          email: 'test@example.com',
          phone: '1234567890',
          password: 'password123',
          password_confirmation: 'password123',
          address: '123 Main St',
          entryable: Client.new
        )
        expect(user).to be_valid
      end

      it 'is invalid with a duplicate email' do
        User.create!(
          name: 'Existing User',
          email: 'test@example.com',
          phone: '1234567890',
          password: 'password123',
          password_confirmation: 'password123',
          address: '123 Main St',
          entryable: Client.new
        )

        user = User.new(
          name: 'Test User',
          email: 'test@example.com',
          phone: '9876543210',
          password: 'password123',
          password_confirmation: 'password123',
          address: '456 Elm St',
          entryable: Client.new
        )

        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('has already been taken')
      end

      it 'is invalid with an improperly formatted email' do
        user = User.new(
          name: 'Test User',
          email: 'invalid_email',
          phone: '1234567890',
          password: 'password123',
          password_confirmation: 'password123',
          address: '123 Main St',
          entryable: Client.new
        )
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('is invalid')
      end
    end

    context 'verified_tag' do
      it 'is valid with a nil verified_tag (presence: false)' do
        user = User.new(
          name: 'Test User',
          email: 'test@example.com',
          phone: '1234567890',
          password: 'password123',
          password_confirmation: 'password123',
          address: '123 Main St',
          verified_tag: nil,
          entryable: Client.new
        )
        expect(user).to be_valid
      end
    end
  end

  describe "default scope" do
    let!(:rider1) { create(:user,  entryable: create(:rider), verified_tag: true) }
    let!(:rider2) { create(:user,  entryable: create(:rider), verified_tag: false) }
    it "selects only the verified users" do
      # Expected users as per the default scope
      expect(User.all).to include rider1
      expect(User.all).not_to include rider2
    end
  end
end
