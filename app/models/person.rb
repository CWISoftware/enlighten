# == Schema Information
#
# Table name: people
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  image_id     :string
#  notification :boolean
#

class Person < ActiveRecord::Base
  include Cardify

  has_paper_trail

  belongs_to :user
  has_many :memberships, class_name: ProjectMember.name
  has_many :technologies, class_name: PersonTechnology.name
  has_many :activities, -> { order(created_at: :desc) }, as: :activity_owner
  has_many :social_links, class_name: SocialLink.name

  has_and_belongs_to_many :followers,
                          class_name: User.name,
                          join_table: :users_following_people

  has_and_belongs_to_many :likers,
                          class_name: User.name,
                          join_table: :users_liking_people

  has_one :card, as: :cardable, dependent: :destroy

  accepts_nested_attributes_for :technologies
  accepts_nested_attributes_for :social_links

  validates :name, presence: true

  attachment :image

  # Returns the activities posted on the persons's timeline and posted by the
  # person's user on other timelines.
  def all_activities
    if user.present?
      Activity.where('(activity_owner_id = :activity_owner_id and activity_owner_type = :activity_owner_type) or user_id = :user_id',
                     activity_owner_id: id, activity_owner_type: self.class.name, user_id: user.id).order(created_at: :desc)
    else
      activities
    end
  end
end
