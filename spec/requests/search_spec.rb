require 'rails_helper'

RSpec.describe "Searches", type: :request do
  let(:test_user) { create(:user) }
  before :each do
    sign_in test_user
  end

  describe "index" do
    # Statuses
    it "redirects on empty query param" do
      get search_path
      expect(response).to redirect_to authenticated_root_path
    end
    it "returns http success with query param" do
      get search_path(query: 'test')
      expect(response).to have_http_status(:success)
    end
    it "redirects to login page when not logged in" do
      test_not_logged_in(search_path(query: 'test'), test_user)
    end

    # Exposed variables
    it "exposes the results" do
      get search_path(query: 'test')
      expect(assigns(:results)).to be_a(PG::Result)
    end
    it "exposes the query" do
      get search_path(query: 'test')
      expect(assigns(:query)).to eq('test')
    end

    # Other
    it "returns results from projects" do
      project = create(:project, user: test_user)
      get search_path(query: project.title)
      expect(assigns(:results).count).to eq(1)
    end
    it "returns results from tasks" do
      project = create(:project, user: test_user)
      task = create(:task, user: test_user, project: project)
      get search_path(query: task.title)
      expect(assigns(:results).count).to eq(1)
    end
    it "returns results from tags" do
      tag = create(:tag, user: test_user)
      get search_path(query: tag.title)
      expect(assigns(:results).count).to eq(1)
    end
    it "returns results from projects, tasks, and tags" do
      project = create(:project, user: test_user, title: 'test project')
      create(:task, user: test_user, project: project, title: 'test task')
      create(:tag, user: test_user, title: 'test tag')
      get search_path(query: 'test')
      expect(assigns(:results).count).to eq(3)
    end
    it "does not return results from other users" do
      project = create(:project, user: test_user)
      different_user = create(:user)
      create(:project, user: different_user)
      get search_path(query: project.title)
      expect(assigns(:results).count).to eq(1)

      different_user.destroy!
    end
  end
end
