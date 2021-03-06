# == Schema Information
#
# Table name: permission_roles
#
#  id         :integer          not null, primary key
#  name       :string
#  default    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :permission_role, class: Permission::Role do
    name { Faker::Name.name }

    trait :administrator do
      name 'Administrator'
    end

    trait :user do
      name 'User'
    end
  end
end
