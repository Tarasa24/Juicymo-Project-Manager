require 'rails_helper'
require 'requests/shared/shared_tests'

RSpec.describe "Tasks", type: :request do
  let(:test_user) { create(:user) }
  let(:test_project) { create(:project, user: test_user) }
  before :each do
    sign_in test_user
  end

  describe "index" do
    # Statuses
    it "should return a 200 response on valid request" do
      get tasks_path
      expect(response).to have_http_status(200)
    end
    it "should return a 200 response when searching" do
      get tasks_path, params: { query: "test" }
      expect(response).to have_http_status(200)
    end
    it "should redirect to login page when not logged in" do
      test_not_logged_in(tasks_path, test_user)
    end

    # Exposed variables
    it "should expose the tasks" do
      get tasks_path
      expect(assigns(:tasks)).to be_a(ActiveRecord::Relation)
    end
    it "should use pagy to paginate" do
      get tasks_path
      expect(assigns(:pagy)).to be_a(Pagy)
    end
    it "should expose the tags" do
      get tasks_path
      expect(assigns(:tags)).to be_a(ActiveRecord::Relation)
    end

    # Other
    it "should not show tasks from other users" do
      create(:task, user: test_user, project: test_project)
      different_user = create(:user)
      different_project = create(:project, user: different_user)
      create(:task, user: different_user, project: different_project)

      get tasks_path
      expect(assigns(:tasks).count).to eq(1)

      different_user.destroy!
    end
  end

  describe "show" do
    # Statuses
    it "should return a 200 response on valid request" do
      task = create(:task, user: test_user, project: test_project)
      get project_task_path(test_project, task)
      expect(response).to have_http_status(200)
    end
    it "should redirect to login page when not logged in" do
      task = create(:task, user: test_user, project: test_project)
      test_not_logged_in(project_task_path(test_project, task), test_user)
    end

    # Exposed variables
    it "should expose the task" do
      task = create(:task, user: test_user, project: test_project)
      get project_task_path(test_project, task)
      expect(assigns(:task)).to eq(task)
    end

    # Other
    it "should not show tasks from other users" do
      create(:task, user: test_user, project: test_project)
      different_user = create(:user)
      task = create(:task, user: different_user, project: test_project)
      get project_task_path(test_project, task)
      expect(response).to have_http_status(302)

      different_user.destroy!
    end
  end

  describe "new" do
    # Statuses
    it "should return a 200 response on valid request" do
      get new_project_task_path(test_project)
      expect(response).to have_http_status(200)
    end
    it "should redirect to login page when not logged in" do
      test_not_logged_in(new_project_task_path(test_project), test_user)
    end

    # Exposed variables
    it "should expose the task" do
      get new_project_task_path(test_project)
      expect(assigns(:task)).to be_a(Task)
    end
  end

  describe "create" do
    # Statuses
    it "should return a 302 response on valid request" do
      post project_tasks_path(test_project), params: { task: attributes_for(:task) }
      expect(response).to have_http_status(302)
    end
    it "should redirect to login page when not logged in" do
      test_not_logged_in(tasks_path, test_user)
    end

    # Exposed variables
    it "should expose the task" do
      post project_tasks_path(test_project), params: { task: attributes_for(:task) }
      expect(assigns(:task)).to be_a(Task)
    end

    # Other
    it "should create a task" do
      expect {
        post project_tasks_path(test_project), params: { task: attributes_for(:task) }
      }.to change(Task, :count).by(1)
    end
  end

  describe "edit" do
    # Statuses
    it "should return a 200 response on valid request" do
      task = create(:task, user: test_user, project: test_project)
      get edit_project_task_path(test_project, task)
      expect(response).to have_http_status(200)
    end
    it "should redirect to login page when not logged in" do
      task = create(:task, user: test_user, project: test_project)
      test_not_logged_in(edit_project_task_path(test_project, task), test_user)
    end

    # Exposed variables
    it "should expose the task" do
      task = create(:task, user: test_user, project: test_project)
      get edit_project_task_path(test_project, task)
      expect(assigns(:task)).to eq(task)
    end

    # Other
    it "should not show tasks from other users" do
      create(:task, user: test_user, project: test_project)
      different_user = create(:user)
      different_project = create(:project, user: different_user)
      task = create(:task, user: different_user, project: different_project)
      get edit_project_task_path(test_project, task)
      expect(response).to have_http_status(302)

      different_user.destroy!
    end
  end

  describe "update" do
    # Statuses
    it "should return a 302 response on valid request" do
      task = create(:task, user: test_user, project: test_project)
      put project_task_path(test_project, task), params: { task: attributes_for(:task) }
      expect(response).to have_http_status(302)
    end
    it "should redirect to login page when not logged in" do
      task = create(:task, user: test_user, project: test_project)
      test_not_logged_in(project_task_path(test_project, task), test_user)
    end

    # Exposed variables
    it "should expose the task" do
      task = create(:task, user: test_user, project: test_project)
      put project_task_path(test_project, task), params: { task: attributes_for(:task) }
      expect(assigns(:task)).to eq(task)
    end

    # Other
    it "should update a task" do
      task = create(:task, user: test_user, project: test_project)
      put project_task_path(test_project, task), params: { task: attributes_for(:task, title: "test") }
      expect(task.reload.title).to eq("test")
    end
    it "should not update a task from other users" do
      create(:task, user: test_user, project: test_project)
      different_user = create(:user)
      different_project = create(:project, user: different_user)
      task = create(:task, user: different_user, project: different_project)
      put project_task_path(test_project, task), params: { task: attributes_for(:task, title: "test") }
      expect(response).to have_http_status(302)

      different_user.destroy!
    end
  end

  describe "destroy" do
    # Statuses
    it "should return a 302 response on valid request" do
      task = create(:task, user: test_user, project: test_project)
      delete project_task_path(test_project, task)
      expect(response).to have_http_status(302)
    end
    it "should redirect to login page when not logged in" do
      task = create(:task, user: test_user, project: test_project)
      test_not_logged_in(project_task_path(test_project, task), test_user)
    end

    # Exposed variables
    it "should expose the task" do
      task = create(:task, user: test_user, project: test_project)
      delete project_task_path(test_project, task)
      expect(assigns(:task)).to eq(task)
    end

    # Other
    it "should destroy a task" do
      task = create(:task, user: test_user, project: test_project)
      expect {
        delete project_task_path(test_project, task)
      }.to change(Task, :count).by(-1)
    end
    it "should not destroy a task from other users" do
      create(:task, user: test_user, project: test_project)
      different_user = create(:user)
      different_project = create(:project, user: different_user)
      task = create(:task, user: different_user, project: different_project)
      delete project_task_path(test_project, task)
      expect(response).to have_http_status(302)

      different_user.destroy!
    end
  end
end
