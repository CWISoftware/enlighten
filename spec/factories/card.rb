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

FactoryGirl.define do
  factory :card, class: Card do
    section       { Faker::Lorem.word }
    title         { Faker::Lorem.word }
    subtitle      { Faker::Lorem.word }
    description   { Faker::Lorem.paragraph }
    size          { Faker::Number.between(1, 4) }
  end
end
