class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = Task.where(user_id: current_user.id)
  end

  def new
    @task = Task.new
    @project = Project.find_by(id: params[:project_id])
  end

  def create
    # Check if project exists
    @project = Project.find_by(id: params[:project_id])
    if @project.nil?
      redirect_to projects_path, alert: 'Project not found.'
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
    redirect_to project_path(params[:project_id])
  end

  def show
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      redirect_to projects_path, alert: 'Task not found.'
      return
    end

    # Check if user is the owner of the project
    check_ownership(@task.project)

    @project = @task.project
  end

  def edit
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      redirect_to projects_path, alert: 'Task not found.'
      return
    end

    # Check if user is the owner of the project
    check_ownership(@task.project)

    @project = @task.project
  end

  def update
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      redirect_to projects_path, alert: 'Task not found.'
      return
    end

    # Check if user is the owner of the project
    check_ownership(@task.project)

    @task.update(task_params)
    redirect_to project_path(params[:project_id])
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      redirect_to projects_path, alert: 'Task not found.'
      return
    end

    # Check if user is the owner of the project
    check_ownership(@task.project)

    @task.destroy
    redirect_to project_path(params[:project_id])
  end

  private
    def task_params
      params.require(:task).permit(:title, :description, :is_done)
    end

    def check_ownership(project)
      if project.user_id != current_user.id
        redirect_to projects_path, alert: 'You are not the owner of this project.'
        return
      end
    end
end
