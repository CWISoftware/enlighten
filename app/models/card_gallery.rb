# == Schema Information
#
# Table name: card_galleries
#
#  id            :integer          not null, primary key
#  card_id       :integer
#  timeout       :integer
#  order         :integer
#  attachment_id :string
#

class CardGallery < ActiveRecord::Base
  belongs_to :card
  attachment :attachment
end
