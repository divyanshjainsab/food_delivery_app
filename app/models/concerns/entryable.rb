module Entryable
  extend ActiveSupport::Concern

  included do
    has_one :user, as: :entryable, dependent: :destroy, touch: true
    
    # default scope to avoid unauthorized users login
    default_scope { joins(:user).where(user: {verified_tag: true}).select([:id, :entryable_type, :entryable_id, :email, :phone, :name, :address]) }
  end
end
