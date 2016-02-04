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

require 'rails_helper'

RSpec.describe Person, type: :model do
  it { expect(subject).to have_db_column(:id) }
  it { expect(subject).to have_db_column(:user_id) }
  it { expect(subject).to have_db_column(:name) }
  it { expect(subject).to have_db_column(:created_at) }
  it { expect(subject).to have_db_column(:updated_at) }
  it { expect(subject).to have_db_column(:notification) }

  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to have_many(:memberships) }
  it { expect(subject).to have_many(:social_links) }
  it { expect(subject).to have_and_belong_to_many(:followers) }
  it { expect(subject).to have_and_belong_to_many(:likers) }

  it { expect(subject).to validate_presence_of(:name) }

  describe '#projects' do
    it 'associates person projects' do
      person = create :person
      membership = create :project_member, project: create(:project)

      person.memberships << membership
      person.save
      person.reload

      expect(person.memberships).to eq [membership]
    end
  end

  describe '#technologies' do
    it 'associates person technologies' do
      person = create :person
      person_technology = create :person_technology, technology: create(:technology)

      person.technologies << person_technology
      person.save
      person.reload

      expect(person.technologies).to eq [person_technology]
    end
  end

  describe '#activities' do
    let(:person) { create :person }

    it 'associates person activities in decrescent publish order' do
      posts_a = create(:post)
      posts_b = create(:post)

      person.activities.create item: posts_a, user: create(:user)
      person.activities.create item: posts_b, user: create(:user)

      person.reload

      expect(person.activities).to have(2).items

      expect(person.activities.first.item).to eq posts_b
      expect(person.activities.second.item).to eq posts_a
    end
  end

  describe '#all_activities' do
    context 'when person have user' do
      let(:person) { create :person }

      it 'lists the activities posted on the person timeline and activities posted by the person' do
        user_activity_a = create(:project).activities.create(item: create(:post), user: person.user)
        user_activity_b = create(:project).activities.create(item: create(:post), user: person.user)
        user_activity_c = person.activities.create item: create(:post), user: create(:user)
        user_activity_d = person.activities.create item: create(:post), user: create(:user)

        expect(person.all_activities).to have(4).items
        expect(person.all_activities).to eq([user_activity_d, user_activity_c,
                                             user_activity_b, user_activity_a])
      end
    end

    context 'when person does not have user' do
      let(:person) { create :person, user_id: nil }

      it { expect { person.all_activities }.not_to raise_exception }
    end
  end

  describe '#followers' do
    let(:person) { create :person }

    it 'user followed people' do
      user = create :user

      user.followed_people << person
      user.save
      user.reload
      person.reload

      expect(person.followers).to eq [user]
    end
  end

  describe '#likers' do
    let(:person) { create :person }

    it 'user liked people' do
      user = create :user

      user.liked_people << person
      user.save
      user.reload
      person.reload

      expect(person.likers).to eq [user]
    end
  end
end
