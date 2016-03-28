# == Schema Information
#
# Table name: card_attachments
#
#  id            :integer          not null, primary key
#  card_id       :integer
#  attachment_id :string
#

class CardAttachment < ActiveRecord::Base
  belongs_to :card
  attachment :attachment
end
