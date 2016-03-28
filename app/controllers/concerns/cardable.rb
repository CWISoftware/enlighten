module Cardable
  extend ActiveSupport::Concern

  included do
    before_action :set_cards, only: [:cards]
    before_action :set_card, only: [:card]
  end

  # GET /model_class/cards.json
  def cards
    respond_to do |format|
      format.json do
        render json: @cards, each_serializer: CardSerializer
      end
    end
  end

  # GET /model_class/1/card.json
  def card
    respond_to do |format|
      format.json do
        render json: @card, serializer: CardSerializer
      end
    end
  end

  protected

  def scope
    self.class.name.gsub(/Controller/, '').downcase
  end

  def set_cards
    @cards = paginate Card.send(scope)
  end

  def set_card
    @card = Card.find(params[:id])
  end
end
