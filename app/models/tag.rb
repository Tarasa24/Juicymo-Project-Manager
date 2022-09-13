class Tag < ApplicationRecord
  # Validations
  validates :name, presence: true
end
