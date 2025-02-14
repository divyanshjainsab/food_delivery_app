class Dish < ApplicationRecord
    # one dish, one image
    has_one_attached :image

    # association
    belongs_to :restaurant
    has_many :orders

    # validation
    validates :name, :description, :price, :category, :status, presence: true
    validates :price, numericality: { greater_than: 0, precision: 10, scale: 2 }
    enum :category, %i[ Veg Non-Veg ]
    enum :status, %i[ In-Stock Out-Of-Stock ]

    default_scope { where(status: "In-Stock") }
end
