class Client < ApplicationRecord
  include Entryable

  # association
  has_many :payments
  has_many :orders
  has_many :reviews
end
