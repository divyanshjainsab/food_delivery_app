module Entryable
  extend ActiveSupport::Concern

  included do
    has_one :user, as: :entryable, dependent: :destroy, touch: true
  end
end
