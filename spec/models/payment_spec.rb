require "rails_helper"

RSpec.describe Payment, type: :model do
  describe "associations" do
    it { should belong_to :client }
    it { should have_one :order }
  end

  describe "validations" do
    it "is vaild with payment_intent_id" do
      payment = build :payment
      # payment_intent_id is genrated in factory
      expect(payment).to be_valid
    end

    it "is invaild without payment_intent_id" do
      payment = build :payment, payment_intent_id: nil
      # payment_intent_id is genrated in factory so override that
      expect(payment).not_to be_valid
    end

    it 'is valid with a unique payment_intent_id' do
      payment = create(:payment)
      expect(payment).to be_valid
    end

    it 'is invalid with a duplicate payment_intent_id' do
      payment1 =  create(:payment)
      payment_intent_id = payment1.payment_intent_id

      # as payment1 is first so it is unique in nature
      expect(payment1).to be_valid

      # payment2 with same payment_intent_id which is now duplicate record
      payment2 = build :payment, payment_intent_id: payment_intent_id
      expect(payment2).not_to be_valid
      expect(payment2.errors[:payment_intent_id]).to include('has already been taken')
    end
  end
end
