# frozen_string_literal: true

class TagsTasks < ApplicationRecord
  # Validations
  validates :tag_id, presence: true
  validates :task_id, presence: true

  # Associations
  belongs_to :tag
  belongs_to :task

  # Scopes
  scope :assigned_tags, -> (task_id) { where(task_id:).pluck(:tag_id) }
end
