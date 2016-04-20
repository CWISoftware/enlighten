# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string
#  website    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image_id   :string
#

class Client < ActiveRecord::Base
  include Cardify

  has_paper_trail

  include Notificatable

  has_many :projects

  has_and_belongs_to_many :followers,
                          class_name: User.name,
                          join_table: :users_following_clients

  has_and_belongs_to_many :likers,
                          class_name: User.name,
                          join_table: :users_liking_clients

  has_one :card, as: :cardable, dependent: :destroy

  validates :name, presence: true

  attachment :image
end
