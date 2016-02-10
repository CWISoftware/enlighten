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

class Card < ActiveRecord::Base
  has_many :galleries, class_name: CardGallery.name
  has_many :attachments, class_name: CardAttachment.name

  belongs_to :cardable, polymorphic: true

  has_and_belongs_to_many :followers,
                          class_name: User.name,
                          join_table: :users_following_cards

  has_and_belongs_to_many :likers,
                          class_name: User.name,
                          join_table: :users_liking_cards

  accepts_nested_attributes_for :galleries, :attachments

  scope :cards,        -> { all.order(created_at: :desc) }
  scope :clients,      -> { where(cardable_type: Client.name).order(created_at: :desc) }
  scope :people,       -> { where(cardable_type: Person.name).order(created_at: :desc) }
  scope :projects,     -> { where(cardable_type: Project.name).order(created_at: :desc) }
  scope :technologies, -> { where(cardable_type: Technology.name).order(created_at: :desc) }
end
