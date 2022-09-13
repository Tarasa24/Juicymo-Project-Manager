class Tag < ApplicationRecord
  # Validations
  validates :name, presence: true

  # Associations
  has_and_belongs_to_many :tasks
  belongs_to :user, null: false
end
