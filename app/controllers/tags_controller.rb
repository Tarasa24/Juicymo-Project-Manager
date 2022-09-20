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

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # POST /tags
  def create
    @tag = Tag.create(tag_params).tap do |t|
      t.user_id = current_user.id
    end

    if @tag.save!
      redirect_to tags_path, notice: t(".success")
    else
      redirect_to tags_path, alert: t(".failure")
    end
  end

  # DELETE /tags/1
  def destroy
    # @tag is already set by set_tag
    if @tag.destroy
      redirect_to tags_path, notice: t(".success")
    else
      redirect_to tags_path, alert: t(".failure")
    end
  end

  private
    # Automatically set the @task variable and redirect if not found
    def set_tags
      @tag = Tag.where(id: params[:id], user_id: current_user.id).first
      redirect_to tags_path, alert: t('.not_found') if @tag.nil?
    end

    # Filter the params
    def tag_params
      params.require(:tag).permit(:title)
    end
end
