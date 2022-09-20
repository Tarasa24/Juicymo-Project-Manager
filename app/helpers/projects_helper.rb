# frozen_string_literal: true

module ProjectsHelper
  # Calculates percentage of finished tasks in a given projects (defined by it's metrics)
  # @param [Hash] project_metrics
  # @return [Float]
  # @example
  #  project_metrics = { "total_tasks" => 10, "completed_tasks" => 5 }
  # -> 50.0
  #  project_metrics = { "total_tasks" => 10, "completed_tasks" => 0 }
  # -> 0.0
  #  project_metrics = { "total_tasks" => 0, "completed_tasks" => 0 }
  # -> 0.0
  # @see Project#self.tasks_metrics
  def calculate_project_progress(project_metrics)
    return 0.0 if project_metrics[:total_tasks].zero?
    (project_metrics[:completed_tasks] / project_metrics[:total_tasks].to_f * 100).round
  end
end
