# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET / (authenticated)
  # GET /projects
  def index
    @projects = Project.where(user_id: current_user.id).order(:position)
    if params[:query].present?
      @projects = @projects.search(params[:query])
    end

    @pagy, @projects = pagy(@projects)
    # Get the project statuses
    @projects_tasks_metrics = Project.tasks_metrics(current_user)
  end

  # GET /projects/1
  def show
    # @project is already set by set_project
    @tags = Tag.for_tasks_in_project(@project)
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    # @project is already set by set_project
  end

  # POST /projects
  def create
    @project = Project.new(title: project_params[:title], user_id: current_user.id)

    if @project.save!
      redirect_to projects_path, notice: t(".success")
    else
      redirect_to projects_path, alert: t(".failure")
    end
  end

  # PATCH/PUT /projects/1
  def update
    # @project is already set by set_project

    # In case user is trying to update the position
    if params[:direction].present?
      if @project.move_position(params[:direction].to_s)
        redirect_to projects_path, notice: t(".success")
      else
        redirect_to projects_path, alert: t(".failure")
      end
    else # Otherwise, update the project
      if @project.update(project_params)
        redirect_to projects_path, notice: t(".success")
      else
        redirect_to projects_path, alert: t(".failure")
      end
    end
  end

  # DELETE /projects/1
  def destroy
    # @project is already set by set_project
    if @project.destroy
      redirect_to projects_url, notice: t(".success")
    else
      redirect_to projects_url, alert: t(".failure")
    end
  end

  private
    # Automatically set the @project variable and redirect if not found
    def set_project
      @project = Project.where(id: params[:id], user_id: current_user.id).first
      redirect_to projects_path, alert: t(".not_found") if @project.nil?
    end

    # Filter the parameters
    def project_params
      params.require(:project).permit(:title)
    end
end
