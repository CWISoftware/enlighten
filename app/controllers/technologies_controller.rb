class TechnologiesController < ApplicationController
  before_action :set_technology, only: [:show, :edit, :update, :destroy]

  include Cardable
  include Likable
  include Followable

  # GET /technologies
  def index
    authorize :technology, :index?
  end

  # GET /technologies/1
  def show
    authorize @technology, :show?
  end

  # GET /technologies/new
  def new
    @technology = Technology.new
    authorize @technology, :new?
  end

  # GET /technologies/1/edit
  def edit
    authorize @technology, :edit?
  end

  # POST /technologies
  def create
    @technology = Technology.new(technology_params)
    authorize @technology, :create?

    if @technology.save
      redirect_to @technology, notice: 'Technology was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /technologies/1
  def update
    authorize @technology, :update?

    if @technology.update(technology_params)
      redirect_to @technology, notice: 'Technology was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /technologies/1
  def destroy
    authorize @technology, :destroy?
    @technology.destroy

    redirect_to technologies_url, notice: 'Technology was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_technology
    @technology = Technology.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def technology_params
    params.require(:technology).permit(:name, :website, :image, :technology_category_id, :parent_id)
  end
end
