# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tags, only: [:show, :edit, :update, :destroy]

  # GET /tags
  def index
    @tags = Tag.where(user_id: current_user.id)

    if params[:query].present?
      @tags = @tags.search(params[:query])
    end

    @pagy, @tags = pagy(@tags)
  end

  # DELETE /tags/1
  def destroy
    # @tag is already set by set_tag
    @tag.destroy

    redirect_to tags_path, notice: "Tag was successfully destroyed."
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # POST /tags
  def create
    @tag = Tag.create(tag_params).tap do |t|
      t.user_id = current_user.id
      t.save!
    end
    redirect_to tags_path
  end

  private
    # Automatically set the @task variable and redirect if not found
    def set_tags
      @tag = Tag.where(id: params[:id], user_id: current_user.id).first
      redirect_to tags_path, alert: "Tag not found." if @tag.nil?
    end

    # Filter the params
    def tag_params
      params.require(:tag).permit(:title)
    end
end
