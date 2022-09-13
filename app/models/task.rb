class Task < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :is_done, inclusion: { in: [true, false] }, presence: true

  # Associations
  belongs_to :project
  has_and_belongs_to_many :tags
end
