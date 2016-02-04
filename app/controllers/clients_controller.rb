class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  include Cardable
  include Likable
  include Followable

  # GET /clients
  def index
    authorize :client, :index?
  end

  # GET /clients/1
  def show
    authorize @client, :show?
  end

  # GET /clients/new
  def new
    @client = Client.new
    authorize @client, :new?
  end

  # GET /clients/1/edit
  def edit
    authorize @client, :edit?
  end

  # POST /clients
  def create
    @client = Client.new(client_params)
    authorize @client, :create?

    if @client.save
      redirect_to @client, notice: 'Client was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /clients/1
  def update
    authorize @client, :update?

    if @client.update(client_params)
      redirect_to @client, notice: 'Client was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /clients/1
  def destroy
    authorize @client, :destroy?
    @client.destroy

    redirect_to clients_url, notice: 'Client was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:client).permit(:name, :website, :image)
  end
end
