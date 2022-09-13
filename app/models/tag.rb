class Tag < ApplicationRecord
  # Validations
  validates :name, presence: true

  # Associations
  has_many :tasks, through: :tags_tasks
  belongs_to :user, foreign_key: true
end
