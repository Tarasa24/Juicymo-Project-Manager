# frozen_string_literal: true

require "rails_helper"

RSpec.describe Task, type: :model do
  let(:test_user) { create(:user) }
  context "validations" do
    test_project = nil
    before :each do
      test_project = FactoryBot.create(:project, user: test_user)
    end

    it "is valid with valid attributes" do
      expect(build(:task, user: test_user, project: test_project)).to be_valid
    end
    it "is not valid without a title" do
      expect(build(:task, user: test_user, project: test_project, title: nil)).to_not be_valid
    end
    it "is not valid without a user" do
      expect(build(:task, user: nil, project: test_project)).to_not be_valid
    end
    it "is not valid with a non-boolean is_done" do
      b1 = build(:task, user: test_user, project: test_project, is_done: "a")
      expect(b1).to be_valid
      expect(b1.is_done).to eq(true) # Any value other than nil defaults to true

      b2 = build(:task, user: test_user, project: test_project, is_done: nil)
      expect(b2).to_not be_valid
    end
    it "is not valid without a project" do
      expect(build(:task, user: test_user, project: nil)).to_not be_valid
    end

    after :each do
      test_project.destroy!
    end
  end

  context "associations" do
    test_project = nil
    test_task = nil
    before :each do
      test_project = FactoryBot.create(:project, user: test_user)
      test_task = FactoryBot.create(:task, user: test_user, project: test_project)
    end

    it "belongs to a project" do
      expect(test_task.project).to eq(test_project)
    end
    it "belongs to a user" do
      expect(test_task.user).to eq(test_user)
    end
    it "has many tags" do
      expect(test_task.tags).to eq([])
    end
    it "has many tags through tags_tasks" do
      test_tag = FactoryBot.create(:tag, user: test_user)
      FactoryBot.create(:tags_tasks, tag: test_tag, task: test_task)

      expect(test_task.tags).to eq([test_tag])
    end

    after :each do
      test_task.destroy!
      test_project.destroy!
    end
  end
end
