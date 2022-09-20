# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  def index
    @tasks = Task.where(user_id: current_user.id).includes(:project)

    if params[:query].present?
      @tasks = @tasks.search(params[:query])
    end

    if params[:scope].present? && params[:scope] != "all"
      @tasks = @tasks.where(is_done: params[:scope] == "done")
    end

    @pagy, @tasks = pagy(@tasks)
    @tags = Tag.left_joins(:tasks)
  end

  # GET /projects/xx/tasks/new
  def new
    @task = Task.new
    @project = Project.find_by(id: params[:project_id])
    @all_tags = Tag.where(user_id: current_user.id)
  end

  # POST /projects/xx/tasks
  def create
    # Check if project exists
    @project = Project.find_by(id: params[:project_id], user_id: current_user.id)
    if @project.nil?
      redirect_to projects_path, alert: t("projects.not_found")
      return
    end

    # Create the task
    @task = Task.create(task_params).tap do |t|
      t.project_id = @project.id
      t.user_id = current_user.id
    end

    if @task.save!
      # Update tags
      unless params[:task][:tags].nil?
        set_tags(params[:task][:tags].select { |t| t != "" })
      end
      redirect_to project_path(params[:project_id]), notice: t(".success")
    else
      redirect_to project_path(params[:project_id]), alert: t(".failure")
    end
  end

  # GET /projects/xx/tasks/1
  def show
    # @task is already set by set_task
  end

  # GET /projects/xx/tasks/1/edit
  def edit
    # @task is already set by set_task
    @all_tags = Tag.where(user_id: current_user.id)
    @checked_tags = TagsTasks.assigned_tags(@task.id)
  end

  # PATCH/PUT /projects/xx/tasks/1
  def update
    # @task is already set by set_task

    # Update the task
    if @task.update(task_params)
      # Update tags (remove all and add new ones)
      unless params[:task][:tags].nil?
        set_tags(params[:task][:tags].select { |t| t != "" })
      end
      redirect_to project_path(params[:project_id]), notice: t(".success")
    else
      redirect_to project_path(params[:project_id]), alert: t(".failure")
    end
  end

  # DELETE /projects/xx/tasks/1
  def destroy
    # @task is already set by set_task
    if @task.destroy
      redirect_to project_path(params[:project_id]), notice: t(".success")
    else
      redirect_to project_path(params[:project_id]), alert: t(".failure")
    end
  end

  private
    # Automatically set the @task variable and redirect if not found
    def set_task
      @task = Task.where(id: params[:id], user_id: current_user.id).first
      redirect_to projects_path, alert: t(".not_found") if @task.nil?
    end

    # Filter the params
    def task_params
      params.require(:task).permit(:title, :description, :is_done, :tags, :file)
    end

    # Sets tags for a task while clearing the old ones
    # @param [Array] new_tags An array of tag ids
    def set_tags(new_tags)
      @task.tags.clear
      new_tags.each do |tag|
        @task.tags << Tag.find_by(id: tag)
      end
    end
end
