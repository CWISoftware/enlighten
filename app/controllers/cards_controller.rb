class CardsController < ApplicationController
  include Cardable
  include Likable
  include Followable

  # GET /cards
  def index
    authorize :card, :index?
  end
end
