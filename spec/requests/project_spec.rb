require 'rails_helper'
require 'requests/shared/shared_tests'

RSpec.describe "Projects", type: :request do
  let(:test_user) { create(:user) }
  before :each do
    sign_in test_user
  end

  describe "index" do
    # Statuses
    it "should return a 200 response on valid request" do
      get projects_path
      expect(response).to have_http_status(200)
    end
    it "should return a 200 response when searching" do
      get projects_path, params: { query: "test" }
      expect(response).to have_http_status(200)
    end
    it "should redirect to login page when not logged in" do
      test_not_logged_in(projects_path, test_user)
    end

    # Exposed variables
    it "should expose the projects" do
      get projects_path
      expect(assigns(:projects)).to be_a(ActiveRecord::Relation)
    end
    it "should use pagy to paginate" do
      get projects_path
      expect(assigns(:pagy)).to be_a(Pagy)
    end
    it "should expose the projects tasks metrics" do
      get projects_path
      expect(assigns(:projects_tasks_metrics)).to be_a(Hash)
    end

    # Other
    it "should not show projects from other users" do
      create(:project, user: test_user)
      different_user = create(:user)
      create(:project, user: different_user)
      get projects_path
      expect(assigns(:projects).count).to eq(1)

      different_user.destroy!
    end
  end

  describe "show" do
    # Statuses
    it "should return a 200 response on valid request" do
      project = create(:project, user: test_user)
      get project_path(project)
      expect(response).to have_http_status(200)
    end
    it "should redirect to login page when not logged in" do
      project = create(:project, user: test_user)
      test_not_logged_in(project_path(project), test_user)
    end
    it "should redirect to projects page when project does not exist" do
      get project_path(1)
      expect(response).to redirect_to(projects_path)
    end

    # Exposed variables
    it "should expose the project" do
      project = create(:project, user: test_user)
      get project_path(project)
      expect(assigns(:project)).to be_a(Project)
    end
    it "should expose the tags" do
      project = create(:project, user: test_user)
      get project_path(project)
      expect(assigns(:tags)).to be_a(ActiveRecord::Relation)
    end
  end

  describe "new" do
    # Statuses
    it "should return a 200 response on valid request" do
      get new_project_path
      expect(response).to have_http_status(200)
    end
    it "should redirect to login page when not logged in" do
      test_not_logged_in(new_project_path, test_user)
    end

    # Exposed variables
    it "should expose the project" do
      get new_project_path
      expect(assigns(:project)).to be_a(Project)
    end
  end

  describe "edit" do
    # Statuses
    it "should return a 200 response on valid request" do
      project = create(:project, user: test_user)
      get edit_project_path(project)
      expect(response).to have_http_status(200)
    end
    it "should redirect to login page when not logged in" do
      project = create(:project, user: test_user)
      test_not_logged_in(edit_project_path(project), test_user)
    end
    it "should redirect to projects page when project does not exist" do
      get edit_project_path(1)
      expect(response).to redirect_to(projects_path)
    end

    # Exposed variables
    it "should expose the project" do
      project = create(:project, user: test_user)
      get edit_project_path(project)
      expect(assigns(:project)).to be_a(Project)
    end
  end

  describe "create" do
    # Statuses
    it "should return a 302 response on valid request" do
      post projects_path, params: { project: { title: "Test" } }
      expect(response).to have_http_status(302)
    end
    it "should redirect to login page when not logged in" do
      test_not_logged_in(projects_path, test_user)
    end

    # Exposed variables
    it "should expose the project" do
      post projects_path, params: { project: { title: "Test" } }
      expect(assigns(:project)).to be_a(Project)
    end

    # Database changes
    it "should create a new project" do
      expect {
        post projects_path, params: { project: { title: "Test" } }
      }.to change(Project, :count).by(1)
    end
  end

  describe "update" do
    # Statuses
    it "should return a 302 response on valid request" do
      project = create(:project, user: test_user)
      put project_path(project), params: { project: { title: "Test" } }
      expect(response).to have_http_status(302)
    end
    it "should redirect to login page when not logged in" do
      project = create(:project, user: test_user)
      test_not_logged_in(project_path(project), test_user)
    end
    it "should redirect to projects page when project does not exist" do
      put project_path(1), params: { project: { title: "Test" } }
      expect(response).to redirect_to(projects_path)
    end

    # Exposed variables
    it "should expose the project" do
      project = create(:project, user: test_user)
      put project_path(project), params: { project: { title: "Test" } }
      expect(assigns(:project)).to be_a(Project)
    end

    # Database changes
    it "should update the project" do
      project = create(:project, user: test_user)
      put project_path(project), params: { project: { title: "Test" } }
      project.reload
      expect(project.title).to eq("Test")
    end
  end

  describe "destroy" do
    # Statuses
    it "should return a 302 response on valid request" do
      project = create(:project, user: test_user)
      delete project_path(project)
      expect(response).to have_http_status(302)
    end
    it "should redirect to login page when not logged in" do
      project = create(:project, user: test_user)
      test_not_logged_in(project_path(project), test_user)
    end
    it "should redirect to projects page when project does not exist" do
      delete project_path(1)
      expect(response).to redirect_to(projects_path)
    end

    # Database changes
    it "should destroy the project" do
      project = create(:project, user: test_user)
      expect {
        delete project_path(project)
      }.to change(Project, :count).by(-1)
    end
  end
end
