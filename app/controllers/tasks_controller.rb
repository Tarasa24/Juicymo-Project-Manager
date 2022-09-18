# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!

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

  def new
    @task = Task.new
    @project = Project.find_by(id: params[:project_id])
    @all_tags = Tag.where(user_id: current_user.id)
  end

  def create
    # Check if project exists
    @project = Project.find_by(id: params[:project_id])
    if @project.nil?
      redirect_to projects_path, alert: "Project not found."
      return
    end

    # Check if user is the owner of the project
    check_ownership(@project)

    # Create the task
    @task = Task.create(task_params).tap do |t|
      t.project_id = @project.id
      t.user_id = current_user.id
      t.save!
    end

    # Add tags
    new_tags = params[:task][:tags].select { |t| t != "" }
    new_tags.each do |tag_id|
      @task.tags << Tag.find_by(id: tag_id)
    end

    redirect_to project_path(params[:project_id])
  end

  def show
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      redirect_to projects_path, alert: "Task not found."
      return
    end

    # Check if user is the owner of the project
    check_ownership(@task.project)

    @project = @task.project
  end

  def edit
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      redirect_to projects_path, alert: "Task not found."
      return
    end

    # Check if user is the owner of the project
    check_ownership(@task.project)
    @all_tags = Tag.where(user_id: current_user.id)
    @checked_tags = TagsTasks.where(task_id: @task.id).pluck(:tag_id)
  end

  def update
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      redirect_to projects_path, alert: "Task not found."
      return
    end

    # Check if user is the owner of the project
    check_ownership(@task.project)

    # Update the task
    @task.update(task_params)

    # Update tags
    unless params[:task][:tags].nil?
      @task.tags.clear
      new_tags = params[:task][:tags].select { |t| t != "" }
      new_tags.each do |tag_id|
        @task.tags << Tag.find_by(id: tag_id)
      end
    end

    redirect_to project_path(params[:project_id])
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      redirect_to projects_path, alert: "Task not found."
      return
    end

    # Check if user is the owner of the project
    check_ownership(@task.project)

    @task.destroy
    redirect_to project_path(params[:project_id])
  end

  private
    def task_params
      params.require(:task).permit(:title, :description, :is_done, :tags, :file)
    end

    def check_ownership(project)
      if project.user_id != current_user.id
        redirect_to projects_path, alert: "You are not the owner of this project."
        nil
      end
    end
end
