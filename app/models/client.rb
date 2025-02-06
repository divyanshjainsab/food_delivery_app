class Client < ApplicationRecord
  include Entryable

  # association
  has_many :payments
  has_many :orders
end
