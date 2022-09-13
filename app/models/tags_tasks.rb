class TagsTasks < ApplicationRecord
  # Associations
  belongs_to :tag
  belongs_to :task

  # Validations
  validates :tag_id, presence: true
  validates :task_id, presence: true
end
