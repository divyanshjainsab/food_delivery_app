class Restaurant < ApplicationRecord
  
  # associations
  include Entryable # belongs to user model
  has_many :dishes

  # validations
  enum :category, %i[ Veg Non-Veg ]
  # fassi licence validation
  validates :fssai_licence, presence: true, format: { with: /\A(15\/|100)[0-9]{4,10}\z/, message: "Invalid FASSI Licence" }
end
