module Entryable
  extend ActiveSupport::Concern

  included do
    has_one :user, as: :entryable, touch: true
  end
end