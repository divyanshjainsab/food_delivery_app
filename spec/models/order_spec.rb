require "rails_helper"

RSpec.describe Order, type: :model do
  describe "associations" do
    it { should belong_to :client }
    it { should belong_to :dish }
    it { should belong_to :payment }

    it 'is valid without a rider' do
      order = create :order
      expect(order).to be_valid
    end

    it 'is valid with a rider' do
      rider = create :rider
      order = create :order, rider: rider
      expect(order).to be_valid
      expect(order.rider).to eq(rider)
    end
  end

  describe "validations" do
    it "has a Processing status" do
      order = create :order, status: "Processing"
      expect(order.status).to eq("Processing")
      expect(order.Processing?).to be true
      expect(order.Prepared?).to be false
      expect(order.Out_For_Delivery?).to be false
      expect(order.Delivered?).to be false
      expect(order.Rejected?).to be false
      expect(order.Cancelled?).to be false
    end

    it "has a Prepared status" do
      order = create :order, status: "Prepared"
      expect(order.status).to eq("Prepared")
      expect(order.Processing?).to be false
      expect(order.Prepared?).to be true
      expect(order.Out_For_Delivery?).to be false
      expect(order.Delivered?).to be false
      expect(order.Rejected?).to be false
      expect(order.Cancelled?).to be false
    end

    it "has a Out_For_Delivery status" do
      order = create :order, status: "Out_For_Delivery"
      expect(order.status).to eq("Out_For_Delivery")
      expect(order.Processing?).to be false
      expect(order.Prepared?).to be false
      expect(order.Out_For_Delivery?).to be true
      expect(order.Delivered?).to be false
      expect(order.Rejected?).to be false
      expect(order.Cancelled?).to be false
    end

    it "has a Delivered status" do
      order = create :order, status: "Delivered"
      expect(order.status).to eq("Delivered")
      expect(order.Processing?).to be false
      expect(order.Prepared?).to be false
      expect(order.Out_For_Delivery?).to be false
      expect(order.Delivered?).to be true
      expect(order.Rejected?).to be false
      expect(order.Cancelled?).to be false
    end


    it "has a Rejected status" do
      order = create :order, status: "Rejected"
      expect(order.status).to eq("Rejected")
      expect(order.Processing?).to be false
      expect(order.Prepared?).to be false
      expect(order.Out_For_Delivery?).to be false
      expect(order.Delivered?).to be false
      expect(order.Rejected?).to be true
      expect(order.Cancelled?).to be false
    end

    it "has a Cancelled status" do
      order = create :order, status: "Cancelled"
      expect(order.status).to eq("Cancelled")
      expect(order.Processing?).to be false
      expect(order.Prepared?).to be false
      expect(order.Out_For_Delivery?).to be false
      expect(order.Delivered?).to be false
      expect(order.Rejected?).to be false
      expect(order.Cancelled?).to be true
    end

    it "stores the correct integer value in the database for status Processing" do
      order = create :order, status: "Processing"
      expect(order.status).to eq("Processing")
      expect(order.status_before_type_cast).to eq(0)
    end

    it "stores the correct integer value in the database for status Processing" do
      order = create :order, status: "Prepared"
      expect(order.status).to eq("Prepared")
      expect(order.status_before_type_cast).to eq(1)
    end

    it "stores the correct integer value in the database for status Processing" do
      order = create :order, status: "Out_For_Delivery"
      expect(order.status).to eq("Out_For_Delivery")
      expect(order.status_before_type_cast).to eq(2)
    end

    it "stores the correct integer value in the database for status Processing" do
      order = create :order, status: "Delivered"
      expect(order.status).to eq("Delivered")
      expect(order.status_before_type_cast).to eq(3)
    end

    it "stores the correct integer value in the database for status Processing" do
      order = create :order, status: "Rejected"
      expect(order.status).to eq("Rejected")
      expect(order.status_before_type_cast).to eq(4)
    end

    it "stores the correct integer value in the database for status Processing" do
      order = create :order, status: "Cancelled"
      expect(order.status).to eq("Cancelled")
      expect(order.status_before_type_cast).to eq(5)
    end

    it "is invalid without client id" do
      order = build :order, client: nil
      expect(order).not_to be_valid
    end

    it "is invalid without payment id" do
      order = build :order, payment: nil
      expect(order).not_to be_valid
    end

    it "is invalid without dish id" do
      order = build :order, dish: nil
      expect(order).not_to be_valid
    end

    it "is valid with client id" do
      order = build :order, client: create(:client)
      expect(order).to be_valid
    end

    it "is valid with payment id" do
      order = build :order, payment: create(:payment)
      expect(order).to be_valid
    end

    it "is valid with dish id" do
      order = build :order, dish: create(:dish)
      expect(order).to be_valid
    end

    it "is valid with client, payment and dish id" do
      order = build :order, dish: create(:dish), payment: create(:payment), client: create(:client)
      expect(order).to be_valid
    end

    it "is invalid without category" do
      order = build :order, status: nil
      expect(order).not_to be_valid
      expect(order.errors[:status]).to include "can't be blank"
    end

    describe 'validations' do
      it 'is valid with a unique payment_id' do
        order = create :order, payment: create(:payment)
        expect(order).to be_valid
      end

      it 'is invalid with a duplicate payment_id' do
        payment =  create(:payment)

        # order1 with payment which is unique for first time
        order1 = create :order, dish: create(:dish), payment: payment, client: create(:client)
        expect(order1).to be_valid

        # order2 with same payment which is now duplicate record
        order2 = build :order, dish: create(:dish), payment: payment, client: create(:client)
        expect(order2).not_to be_valid
        expect(order2.errors[:payment_id]).to include('has already been taken')
      end
    end
  end
end
