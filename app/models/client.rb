class Client < ApplicationRecord
  include Entryable

  # association
  has_many :payments
end
