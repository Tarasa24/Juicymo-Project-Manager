# frozen_string_literal: true

require "rails_helper"

RSpec.describe Project, type: :model do
  let(:test_user) { create(:user) }
  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:project, user: test_user)).to be_valid
    end
    it "is not valid without a name" do
      expect(build(:project, user: test_user, title: nil)).to_not be_valid
    end
    it "is not valid without a user" do
      expect(build(:project, user: nil)).to_not be_valid
    end
    it "is not valid with a non-integer position" do
      expect(build(:project, user: test_user, position: "a")).to_not be_valid
    end
  end

  context "associations" do
    test_project = nil
    before :each do
      test_project = create(:project, user: test_user)
    end
    after :each do
      test_project.destroy
    end

    it "has many tasks" do
      expect(test_project.tasks).to eq([])
    end
    it "belongs to a user" do
      expect(test_project.user).to eq(test_user)
    end
  end

  context "methods" do
    context "tasks_metrics" do
      it "returns the correct number of total tasks" do
        test_project = create(:project, user: test_user)
        n = 5
        FactoryBot.create_list(:task, n, project: test_project, user: test_user)
        expect(Project.tasks_metrics(test_user)[test_project.id][:total_tasks]).to eq(n)
      end
      it "returns the correct number of completed tasks" do
        test_project = create(:project, user: test_user)
        n = 3
        FactoryBot.create_list(:task, n, project: test_project, user: test_user, is_done: true)
        FactoryBot.create(:task, project: test_project, user: test_user, is_done: false)
        expect(Project.tasks_metrics(test_user)[test_project.id][:completed_tasks]).to eq(n)
      end
    end
    context "move_position" do
      it "moves a project to the correct position with direction up" do
        test_project1 = create(:project, user: test_user)
        test_project2 = create(:project, user: test_user)
        test_project2.move_position("up")
        expect(test_project2.position).to eq(test_project1.position)
      end

      it "moves a project to the correct position with direction down" do
        test_project1 = create(:project, user: test_user)
        test_project2 = create(:project, user: test_user)
        test_project1.move_position("down")
        expect(test_project1.position).to eq(test_project2.position)
      end
    end
    context "set_position" do
      it "sets the correct position for a new project" do
        test_project = Project.create(title: Faker::Lorem.word, user: test_user)
        expect(test_project.position).to eq(1)
      end
      it "sets the correct position for a new project with existing projects" do
        Project.create(title: Faker::Lorem.word, user: test_user)
        test_project2 = Project.create(title: Faker::Lorem.word, user: test_user)
        expect(test_project2.position).to eq(2)
      end
    end
    context "update_positions_after_destroy" do
      it "updates the positions of the projects after a project is destroyed" do
        test_project1 = create(:project, user: test_user)
        test_project2 = create(:project, user: test_user)
        test_project3 = create(:project, user: test_user)
        test_project2.destroy
        expect(test_project1.reload.position).to eq(1)
        expect(test_project3.reload.position).to eq(2)
      end
    end
  end
end
