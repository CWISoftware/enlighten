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

FactoryGirl.define do
  factory :person, class: Person do
    user_id { create(:user).id }
    name { Faker::Name.name }
    notification true

    trait :without_notification do
      notification false
    end
  end

  factory :invalid_person, class: Person do
    user_id nil
    name ''
  end
end
