# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProjectsHelper, type: :helper do
  context "calculate_project_progress" do
    it "calculates percentage of finished tasks in a given projects (defined by it's metrics)" do
      project_metrics = { total_tasks: 10, completed_tasks: 10 }
      expect(helper.calculate_project_progress(project_metrics)).to eq(100.0)
      project_metrics = { total_tasks: 10, completed_tasks: 5 }
      expect(helper.calculate_project_progress(project_metrics)).to eq(50.0)
      project_metrics = { total_tasks: 10, completed_tasks: 0 }
      expect(helper.calculate_project_progress(project_metrics)).to eq(0.0)
      project_metrics = { total_tasks: 0, completed_tasks: 0 }
      expect(helper.calculate_project_progress(project_metrics)).to eq(0.0)
    end
  end
end
