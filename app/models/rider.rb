class Rider < ApplicationRecord
  include Entryable

   enum :status, %i[ free busy]
end
