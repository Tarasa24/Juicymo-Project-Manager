# frozen_string_literal: true

class Project < ApplicationRecord
  after_destroy :update_positions_after_destroy
  before_validation :set_position, on: :create

  # Validations
  validates :title, presence: true
  validates :position, presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  # Associations
  has_many :tasks, dependent: :destroy
  belongs_to :user

  # Scopes
  include CommonScopes

  # Methods

  # Get metrics about the project's tasks
  # @param user [User] The user
  # @return [Hash] The metrics
  # @example
  #  Project.tasks_metrics(user)
  # # => { 1 => { total_tasks: 3, completed_tasks: 1 }, 2 => { total_tasks: 2, completed_tasks: 0 } }
  def self.tasks_metrics(user)
    select("project.id AS project_id",
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

    # Set the position of the project to the last position + 1
    def set_position
      if position.nil?
        last_project = Project.where(user_id:).order(position: :desc).first
        self.position = last_project ? last_project.position + 1 : 1
      end
    end

    # Update positions of projects after a project that has been destroyed
    def update_positions_after_destroy
      Project.where(user_id: self.user.id).where("position > ?", self.position).update_all("position = position - 1")
    end
end
