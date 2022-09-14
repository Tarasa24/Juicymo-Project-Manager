class Project < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :position, presence: true

  # Associations
  has_many :tasks, dependent: :destroy
  belongs_to :user

  # Methods
  def self.create_with_position(title, user)
    # Get the last project position
    last_project = Project.where(user_id: user.id).order(position: :desc).first
    position = last_project ? last_project.position + 1 : 1

    Project.create(title: title, position: position, user_id: user.id)
  end

  # Get metrics about the project's tasks
  # @param user [User] The user
  # @return [Hash] The project statuses
  # @example
  #  Project.tasks_metrics(user)
  # # => { 1 => { total_tasks: 3, completed_tasks: 1 }, 2 => { total_tasks: 2, completed_tasks: 0 } }
  def self.tasks_metrics(user)
    Project.select('project.id AS project_id',
                   'COUNT(task.id) AS total_tasks',
                   'SUM(CASE WHEN task.is_done = true THEN 1 ELSE 0 END) AS completed_tasks')
           .from('projects AS project')
           .joins('LEFT JOIN tasks AS task ON task.project_id = project.id')
           .where('project.user_id = ?', user.id)
           .group('project.id')
           .to_h { |project| [project.project_id, project] }
  end
end
