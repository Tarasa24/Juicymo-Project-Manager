class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(current_user.id)
  end
end
