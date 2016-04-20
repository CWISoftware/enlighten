module Cardify
  extend ActiveSupport::Concern

  included do
    after_create { cardify! }
    after_update { cardify! }
  end

  private

  def render_partial(file)
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.extend ApplicationHelper
    view.render(partial: "#{self.class.name.downcase.pluralize}/cards/#{file}", locals: { model: self })
  end

  def cardify!
    Card.create(
      section: I18n.translate("cards.#{self.class.name.downcase}"),
      title: render_partial(:title),
      subtitle: render_partial(:subtitle),
      description: render_partial(:description),
      size: 1,
      cardable: self
    )
  end
end
