class CardsController < ApplicationController
  include Cardable
  include Likable
  include Followable

  # GET /cards
  def index
    authorize :card, :index?
  end

  # GET /cards/new
  def new
    @card = Card.new
    # authorize @card, :new?
  end

  # POST /cards
  def create
    @card = Card.new(card_params)
    # authorize @card, :create?

    if @card.save
      redirect_to @card, notice: 'Card was successfully created.'
    else
      render :new
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def card_params
    params.require(:card).permit(
      :section,
      :title,
      :subtitle,
      :description,
      :style,
      :size,
      galleries_attributes: [:id, :card_id, :timeout, :order, :attachment_id, :_destroy])
  end
end
