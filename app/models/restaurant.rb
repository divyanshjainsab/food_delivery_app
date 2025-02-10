class Restaurant < ApplicationRecord
  
  # associations
  include Entryable # belongs to user model
  has_many :dishes
  has_many :orders, through: :dishes
  has_many :reviews

  # validations
  enum :category, %i[ Veg Non-Veg ]
  has_one_attached :avatar

  # fassi licence validation
  validates :fssai_licence, presence: true, format: { with: /\A(15\/|100)[0-9]{4,10}\z/, message: "Invalid FASSI Licence" }


  default_scope { select(:category)}
end
