require 'rails_helper'

RSpec.describe TagsTasks, type: :model do
  let(:test_user) { create(:user) }
  context "validations" do
    it "is valid with valid attributes" do
      test_project = FactoryBot.create(:project, user: test_user)
      test_task = FactoryBot.create(:task, user: test_user, project: test_project)
      test_tag = FactoryBot.create(:tag, user: test_user)

      expect(build(:tags_tasks, tag: test_tag, task: test_task)).to be_valid
    end
    it "is not valid without a tag" do
      test_project = FactoryBot.create(:project, user: test_user)
      test_task = FactoryBot.create(:task, user: test_user, project: test_project)

      expect(build(:tags_tasks, tag: nil, task:test_task)).to_not be_valid
    end
    it "is not valid without a task" do
      test_tag = FactoryBot.create(:tag, user: test_user)

      expect(build(:tags_tasks, task: nil, tag: test_tag)).to_not be_valid
    end
  end

  context "associations" do
    it "belongs to a tag" do
      test_project = FactoryBot.create(:project, user: test_user)
      test_task = FactoryBot.create(:task, user: test_user, project: test_project)
      test_tag = FactoryBot.create(:tag, user: test_user)
      test_tags_tasks = FactoryBot.create(:tags_tasks, tag: test_tag, task: test_task)

      expect(test_tags_tasks.tag).to eq(test_tag)
    end
    it "belongs to a task" do
      test_project = FactoryBot.create(:project, user: test_user)
      test_task = FactoryBot.create(:task, user: test_user, project: test_project)
      test_tag = FactoryBot.create(:tag, user: test_user)
      test_tags_tasks = FactoryBot.create(:tags_tasks, tag: test_tag, task: test_task)

      expect(test_tags_tasks.task).to eq(test_task)
    end
  end

  context "scopes" do
    it "returns the correct tag ids" do
      test_project = FactoryBot.create(:project, user: test_user)
      test_task = FactoryBot.create(:task, user: test_user, project: test_project)
      test_tag = FactoryBot.create(:tag, user: test_user)
      FactoryBot.create(:tags_tasks, tag: test_tag, task: test_task)

      expect(TagsTasks.assigned_tags(test_task.id)).to eq([test_tag.id])
    end
  end
end
