# == Schema Information
#
# Table name: cards
#
#  id            :integer          not null, primary key
#  section       :string
#  title         :string
#  subtitle      :string
#  description   :text
#  style         :text
#  size          :integer
#  cardable_id   :integer
#  cardable_type :string
#

class CardSerializer < ActiveModel::Serializer
  attributes :id, :section, :title, :subtitle, :description, :avatar, :links, :style, :size, :statistics, :attachments, :galleries

  def avatar
    helpers.attachment_url(model, :image, :fill, 300, 300, format: 'png') if object.cardable
  end

  def size
    object.size * 3
  end

  def links
    links = {}
    links[:self]       = polymorphic_path(model)
    links[:cardable]   = polymorphic_path(model, action: :card, format: :json)
    links[:likable]    = likable_path if likable?
    links[:followable] = followable_path if followable?
    links
  end

  def statistics
    statistics = []
    statistics << { icn: likable_icon, link: likable_path, title: likable_total } if likable?
    statistics << { icn: followable_icon, link: followable_path, title: followable_total } if followable?
    statistics
  end

  private

  def likable_total
    return 0 unless likable?

    model.likers.count
  end

  def likable_icon
    return nil unless likable?

    if liked?
      helpers.image_url('icons/cards/icn-likers-selected.svg')
    else
      helpers.image_url('icons/cards/icn-likers.svg')
    end
  end

  def likable_path
    return nil unless likable?

    if liked?
      polymorphic_path(model, action: :unlike, format: :json)
    else
      polymorphic_path(model, action: :like, format: :json)
    end
  end

  def likable_method_name
    "liked_#{model.class.name.pluralize.downcase}".to_sym
  end

  def likable?
    current_user.respond_to?(likable_method_name)
  end

  def liked?
    current_user.send(likable_method_name).include?(model)
  end

  def followable_total
    return 0 unless followable?

    model.followers.count
  end

  def followable_icon
    return nil unless followable?

    if followed?
      helpers.image_url('icons/cards/icn-followers-selected.svg')
    else
      helpers.image_url('icons/cards/icn-followers.svg')
    end
  end

  def followable_path
    return nil unless followable?

    if followed?
      polymorphic_path(model, action: :unfollow, format: :json)
    else
      polymorphic_path(model, action: :follow, format: :json)
    end
  end

  def followable_method_name
    "followed_#{model.class.name.pluralize.downcase}".to_sym
  end

  def followable?
    current_user.respond_to?(followable_method_name)
  end

  def followed?
    current_user.send(followable_method_name).include?(model)
  end

  def model
    object.cardable || object
  end

  def helpers
    ApplicationController.helpers
  end

  def current_user
    scope
  end
end
