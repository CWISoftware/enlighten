module CardHelper
  
  def card_grid_javascript
    content_for(:head) do
      javascript_include_tag('card-grid')
    end
  end

end
