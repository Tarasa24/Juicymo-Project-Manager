class Project < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :position, presence: true
end
