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
  belongs_to :client
  has_and_belongs_to_many :technologies,
                          join_table: :project_technologies,
                          class_name: Technology.name
  has_many :members, class_name: ProjectMember.name
  has_many :activities, -> { order(created_at: :desc) }, as: :activity_owner

  accepts_nested_attributes_for :members

  validates :name, presence: true

  attachment :image
end
