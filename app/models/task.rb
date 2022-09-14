class Task < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :is_done, inclusion: { in: [true, false] }, presence: true

  # Associations
  belongs_to :project
  has_many :tags, through: :tags_tasks
  belongs_to :user, foreign_key: true
end
