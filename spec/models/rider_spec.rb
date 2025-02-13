require "rails_helper"

RSpec.describe Review, type: :model do
  it "includes Entryable module" do
    expect(Rider.include?(Entryable)).to be true
  end

  describe "default scope" do
    let!(:rider) { create(:user,  entryable: create(:rider), verified_tag: true) }
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
  end

  describe "validations" do
    it "has a Busy status" do
      rider = create :rider, status: "Busy"
      expect(rider.status).to eq("Busy")
      expect(rider.Busy?).to be true
      expect(rider.Available?).to be false
    end

    it "has a Available status" do
      rider = create :rider, status: "Available"
      expect(rider.status).to eq("Available")
      expect(rider.Busy?).to be false
      expect(rider.Available?).to be true
    end

    it "stores the correct integer value in the database for Busy" do
      rider = create :rider, status: "Busy"
      expect(rider.status).to eq("Busy")
      expect(rider.status_before_type_cast).to eq(0)
    end

    it "stores the correct integer value in the database for Available" do
      rider = create :rider, status: "Available"
      expect(rider.status).to eq("Available")
      expect(rider.status_before_type_cast).to eq(1)
    end

    it "is invalid without status" do
      rider = build :rider, status: nil
      expect(rider).not_to be_valid
      expect(rider.errors[:status]).to include "can't be blank"
    end

    it "is invalid without a driving_licence" do
      rider = build :rider, driving_licence: nil
      expect(rider).not_to be_valid
      expect(rider.errors[:driving_licence]).to include "can't be blank"
    end

    it "is invalid without a vehical_number" do
      rider = build :rider, vehical_number: nil
      expect(rider).not_to be_valid
      expect(rider.errors[:vehical_number]).to include "can't be blank"
    end

    it "is invalid without a date_of_birth" do
      rider = build :rider, date_of_birth: nil
      expect(rider).not_to be_valid
      expect(rider.errors[:date_of_birth]).to include "can't be blank"
    end

    it "is valid with a driving_licence, vehical_number, date_of_birth and status" do
      rider = build :rider
      # all these are assigned in factory
      expect(rider).to be_valid
    end

    it "is invalid without a proper vehical_number" do
      rider = build :rider, vehical_number: "ABC-12-1213-OR"
      expect(rider).not_to be_valid
      expect(rider.errors[:vehical_number]).to include "must be in the format: XX-99-XX-9999 (e.g., DL-12-AB-1234)"
    end

    it "is invalid without a proper driving_licence" do
      rider = build :rider, driving_licence: "ABC-12-1CA213-OR"
      expect(rider).not_to be_valid
      expect(rider.errors[:driving_licence]).to include "must be in the format: XX-99-9999-999999 (e.g., DL-12-345678)"
    end
  end
end
