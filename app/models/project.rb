# frozen_string_literal: true

class Project < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :position, presence: true

  # Associations
  has_many :tasks, dependent: :destroy
  belongs_to :user

  # Scopes
  include CommonScopes

  # Methods

  # Creates a new project and sets the position to the last position + 1
  # @param title [String] The title
  # @param user [User] The user
  # @return [Project] The project
  # @example
  # Project.create_with_position("New project", current_user)
  # # => #<Project id: 1, title: "New project", position: 1, ...>
  # Project.create_with_position("New project 2", current_user)
  # # => #<Project id: 2, title: "New project 2", position: 2, ...>
  def self.create_with_position(title, user)
    # Get the last project position
    last_project = Project.where(user_id: user.id).order(position: :desc).first
    position = last_project ? last_project.position + 1 : 1

    Project.create(title:, position:, user_id: user.id)
  end

  # Get metrics about the project's tasks
  # @param user [User] The user
  # @return [Hash] The metrics
  # @example
  #  Project.tasks_metrics(user)
  # # => { 1 => { total_tasks: 3, completed_tasks: 1 }, 2 => { total_tasks: 2, completed_tasks: 0 } }
  def self.tasks_metrics(user)
    Project.select("project.id AS project_id",
                   "COUNT(task.id) AS total_tasks",
                   "SUM(CASE WHEN task.is_done = true THEN 1 ELSE 0 END) AS completed_tasks")
           .from("projects AS project")
           .joins("LEFT JOIN tasks AS task ON task.project_id = project.id")
           .where("project.user_id = ?", user.id)
           .group("project.id")
           .index_by { |project| project.project_id }.to_h
  end

  # Changes the position of the project depending on the parameter
  # @param direction [String] The direction to move the project (up or down)
  # @example
  # project.move("up") # Moves the project up
  # project.move("down") # Moves the project down
  # project.move("invalid") # Does nothing
  # @see move_up
  # @see move_down
  def move_position(direction)
    if direction == "up"
      move_up
    elsif direction == "down"
      move_down
    end
  end

  private

  # Moves the project up. The position of the project is swapped with the previous project.
  def move_up
    # Get the previous project
    previous_project = Project.where(user_id:).where("position < ?", position).order(position: :desc).first

    # Swap the positions
    if previous_project
      previous_project_position = previous_project.position
      previous_project.update(position:)
      update(position: previous_project_position)
    end
  end

  # Moves the project down. The position of the project is swapped with the next project.
  def move_down
    # Get the next project
    next_project = Project.where(user_id:).where("position > ?", position).order(:position).first

    # Swap the positions
    if next_project
      next_project_position = next_project.position
      next_project.update(position:)
      update(position: next_project_position)
    end
  end
end
