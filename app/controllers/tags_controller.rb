class TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @tags = pagy(Tag.where(user_id: current_user.id))
  end

  def destroy
    @tag = Tag.find(params[:id])

    if @tag.user_id == current_user.id
      @tag.destroy
      redirect_to tags_path, notice: 'Tag was successfully deleted.'
    else
      redirect_to tags_path, alert: 'You are not authorized to delete this tag.'
    end
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.create(tag_params).tap do |t|
      t.user_id = current_user.id
      t.save!
    end
    redirect_to tags_path
  end

  private
  def tag_params
    params.require(:tag).permit(:title)
  end
end
