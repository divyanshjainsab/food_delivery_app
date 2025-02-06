class Rider < ApplicationRecord
  include Entryable

  enum :status, %i[ Busy Available ]
  has_many :orders

  validates :driving_licence, :vehical_number, :date_of_birth, :status, presence: true, absence: false

end
