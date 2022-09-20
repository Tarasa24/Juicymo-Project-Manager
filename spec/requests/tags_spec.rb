require 'rails_helper'
require 'requests/shared/shared_tests'

RSpec.describe "Tags", type: :request do
  let(:test_user) { create(:user) }
  before :each do
    sign_in test_user
  end

  describe "index" do
    # Statuses
    it "should return a 200 response on valid request" do
      get tags_path
      expect(response).to have_http_status(200)
    end
    it "should return a 200 response when searching" do
      get tags_path, params: { query: "test" }
      expect(response).to have_http_status(200)
    end
    it "should redirect to login page when not logged in" do
      test_not_logged_in(tags_path, test_user)
    end

    # Exposed variables
    it "should expose the tags" do
      get tags_path
      expect(assigns(:tags)).to be_a(ActiveRecord::Relation)
    end
    it "should use pagy to paginate" do
      get tags_path
      expect(assigns(:pagy)).to be_a(Pagy)
    end

    # Other
    it "should not show tags from other users" do
      create(:tag, user: test_user)
      different_user = create(:user)
      create(:tag, user: different_user)
      get tags_path
      expect(assigns(:tags).count).to eq(1)

      different_user.destroy!
    end
  end

  describe "new" do
    # Statuses
    it "should return a 200 response on valid request" do
      get new_tag_path
      expect(response).to have_http_status(200)
    end
    it "should redirect to login page when not logged in" do
      test_not_logged_in(new_tag_path, test_user)
    end

    # Exposed variables
    it "should expose the tag" do
      get new_tag_path
      expect(assigns(:tag)).to be_a(Tag)
    end
  end

  describe "create" do
    # Statuses
    it "should redirect to the tags page on valid request" do
      post tags_path, params: { tag: { title: "test" } }
      expect(response).to redirect_to(tags_path)
    end
    it "should redirect to login page when not logged in" do
      test_not_logged_in(tags_path, test_user)
    end

    # Other
    it "should create a tag" do
      post tags_path, params: { tag: { title: "test" } }
      expect(Tag.last.title).to eq("test")
    end
    it "should not create a tag with invalid params" do
      expect { post tags_path, params: { tag: { title: "" } } }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "destroy" do
    # Statuses
    it "should redirect to the tags page on valid request" do
      tag = create(:tag, user: test_user)
      delete tag_path(tag)
      expect(response).to redirect_to(tags_path)
    end
    it "should redirect to login page when not logged in" do
      tag = create(:tag, user: test_user)
      test_not_logged_in(tag_path(tag), test_user, 'delete')
    end
    it "should redirect to the tags page when the tag does not exist" do
      delete tag_path(0)
      expect(response).to redirect_to(tags_path)
    end

    # Other
    it "should delete a tag" do
      tag = create(:tag, user: test_user)
      delete tag_path(tag)
      expect(Tag.where(id: tag.id)).to be_empty
    end
    it "should not delete a tag that doesn't belong to the user" do
      tag = create(:tag, user: test_user)
      different_user = create(:user)
      tag.update(user: different_user)
      delete tag_path(tag)
      expect(Tag.where(id: tag.id)).to_not be_empty

      different_user.destroy!
    end
  end
end
