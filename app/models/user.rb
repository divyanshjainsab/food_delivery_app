class User < ApplicationRecord
    has_secure_password
    delegated_type :entryable, types: %w[ Restaurant Rider Client ], dependent: :destroy
    has_one :misc

    validates :password, confirmation: true
    validates :name, :email, :phone, :password, :password_confirmation, :address, presence: true
    validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password,
            length: { minimum: 8 },
            if: -> { new_record? || !password.nil? }
    validates :verified_tag, presence: false

    default_scope { where(verified_tag: true)}

end
