class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  include Cardable
  include Likable
  include Followable

  # GET /people
  def index
    authorize :person, :index?
  end

  # GET /people/1
  def show
    authorize @person, :show?
  end

  # GET /people/new
  def new
    @person = Person.new
    authorize @person, :new?
  end

  # GET /people/1/edit
  def edit
    authorize @person, :edit?
  end

  # POST /people
  def create
    @person = Person.new(person_params)
    authorize @person, :create?

    if @person.save
      redirect_to @person, notice: 'Person was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /people/1
  def update
    authorize @person, :update?

    if @person.update(person_params)
      redirect_to @person, notice: 'Person was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /people/1
  def destroy
    authorize @person, :destroy?
    @person.destroy

    redirect_to people_url, notice: 'Person was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_person
    @person = Person.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def person_params
    params.require(:person).permit(
      :user_id,
      :name,
      :image,
      social_links_attributes: [:id, :provider, :identifier, :_destroy],
      technologies_attributes: [:id, :technology_id, :skill_rating, :certificated, :_destroy])
  end
end
