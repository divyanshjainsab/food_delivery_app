class Rider < ApplicationRecord
  include Entryable

  has_many :orders
  
  # default scope so that status can also retrieved
  default_scope { select(:status)}
  
  enum :status, %i[ Busy Available ]
  validates :driving_licence, :vehical_number, :date_of_birth, :status, presence: true, absence: false
  validates :vehical_number, 
            presence: true, 
            format: { with: /\A[A-Z]{2}-\d{2}-[A-Z]{2}-\d{4}\z/, message: "must be in the format: XX-99-XX-9999 (e.g., DL-12-AB-1234)" }
  validates :licence, 
            presence: true, 
            format: { with: /\A[A-Z]{2}-\d{2}-\d{6}\z/, message: "must be in the format: XX-99-999999 (e.g., DL-12-345678)" }
end
