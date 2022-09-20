require 'rails_helper'

RSpec.describe "Homes", type: :request do
describe "index" do
    it "should be the root page for unauthenticated users" do
      get "/"
      expect(response).to have_http_status(200)
    end
  end
end
