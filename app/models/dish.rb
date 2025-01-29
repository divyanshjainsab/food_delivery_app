class Dish < ApplicationRecord
  # one dish, one image
  has_one_attached :image

  # association
  belongs_to :restaurant

  # validation
  validates :name, :description, :price, presence: true
  validates :price, numericality: {greater_than: 0, precision: 5, scale: 2}
end
