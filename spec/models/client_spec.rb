require 'rails_helper'

RSpec.describe Client, type: :model do
  it "includes Entryable module" do
    expect(Client.include?(Entryable)).to be true
  end

  # describing associations
  describe "associations" do
    it { should have_many(:payments) }
    it { should have_many(:orders) }
    it { should have_many(:reviews) }
  end
end
