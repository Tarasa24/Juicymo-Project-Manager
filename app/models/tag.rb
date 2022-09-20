# frozen_string_literal: true

class Tag < ApplicationRecord
  # Validations
  validates :title, presence: true

  # Associations
  has_many :tags_tasks, class_name: "TagsTasks", dependent: :delete_all
  has_many :tasks, through: :tags_tasks
  belongs_to :user

  # Scopes
  include CommonScopes

  # Finds the tags that are associated with the tasks found in a given project
  # @param project [Project] The project
  scope :for_tasks_in_project, -> (project) { Tag.left_joins(:tasks).where(tasks: { project_id: project.id }) }
end
