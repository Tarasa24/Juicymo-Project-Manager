# frozen_string_literal: true

module ProjectsHelper
  def calculate_project_progress(project_metrics)
    return 0 if project_metrics[:total_tasks].zero?

    (project_metrics[:completed_tasks] / project_metrics[:total_tasks].to_f * 100).round
  end
end
