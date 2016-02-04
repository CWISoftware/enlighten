class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  include Cardable
  include Likable
  include Followable

  # GET /projects
  def index
    authorize :project, :index?
  end

  # GET /projects/1
  def show
    authorize @project, :show?
  end

  # GET /projects/new
  def new
    @project = Project.new
    authorize @project, :new?
  end

  # GET /projects/1/edit
  def edit
    authorize @project, :edit?
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    authorize @project, :create?

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    authorize @project, :update?

    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /projects/1
  def destroy
    authorize @project, :destroy?
    @project.destroy

    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(
      :name,
      :client_id,
      :description,
      :scm_type,
      :scm_reference,
      :image,
      technology_ids: [],
      members_attributes: [:id, :person_id, :role_id, :period_start, :period_end, :_destroy],
      screenshots_attributes: [:id, :image, :description, :_destroy])
  end
end
