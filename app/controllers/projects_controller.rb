class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :verify_owner, only: [:edit, :update, :destroy]

  # GET /
  # GET /projects
  # GET /projects.json
  def index
    @user = current_user
    @projects = Project.where(user_id: @user.id).order(:position)

    # Get the project statuses
    @projects_tasks_metrics = Project.tasks_metrics(@user)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    # Check if project exists
    if @project.nil?
      redirect_to projects_path, alert: 'Project not found.'
      return
    end

    # Get the project statuses
    @projects_tasks_metrics = Project.tasks_metrics(current_user, @project.id)
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.create_with_position(project_params[:title], current_user)

    respond_to do |format|
      if @project.save!
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, alert: 'Project could not be created.' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def move(project, direction)
    respond_to do |format|
      if project.move_position(direction)
        format.html { redirect_to projects_path, notice: 'Project was successfully moved.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { redirect_to projects_path, alert: 'Project could not be moved.' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    if params[:direction].present?
      move(@project, params[:direction])
    else
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to @project, notice: 'Project was successfully updated.' }
          format.json { render :show, status: :ok, location: @project }
        else
          format.html { render :edit }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.where(id: params[:id], user_id: current_user.id).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title)
    end

    def verify_owner
      if @project.user_id != current_user.id
        redirect_to projects_path, alert: 'You are not the owner of this project.'
      end
    end
end
