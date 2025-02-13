require "rails_helper"

RSpec.describe Review, type: :model do
  describe "associations" do
   it { should belong_to :restaurant }
   it { should belong_to :client }
  end
end
