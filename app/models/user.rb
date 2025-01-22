class User < ApplicationRecord
    has_secure_password
    delegated_type :entryable, types: %w[ Restaurant Rider Client ]



    validates :password, confirmation: true
    validates :password_confirmation, presence: true
end
