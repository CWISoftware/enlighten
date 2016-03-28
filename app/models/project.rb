# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  scm_type      :string
#  scm_reference :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  image_id      :string
#  client_id     :integer
#

class Project < ActiveRecord::Base
  include Cardify

  has_paper_trail

  include Notificatable

  belongs_to :client

  has_and_belongs_to_many :technologies,
                          class_name: Technology.name,
                          join_table: :project_technologies

  has_many :members, class_name: ProjectMember.name
  has_many :screenshots, class_name: ProjectScreenshot.name

  has_many :activities, -> { order(created_at: :desc) }, as: :activity_owner

  has_and_belongs_to_many :followers,
                          class_name: User.name,
                          join_table: :users_following_projects

  has_and_belongs_to_many :likers,
                          class_name: User.name,
                          join_table: :users_liking_projects

  has_one :card, as: :cardable, dependent: :destroy

  accepts_nested_attributes_for :members, :screenshots

  validates :name, presence: true

  attachment :image
end
