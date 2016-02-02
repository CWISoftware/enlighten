# == Schema Information
#
# Table name: technologies
#
#  id                     :integer          not null, primary key
#  name                   :string
#  website                :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  image_id               :string
#  technology_category_id :integer
#  parent_id              :integer
#

require 'rails_helper'

RSpec.describe Technology, type: :model do
  it { expect(subject).to have_db_column(:id) }
  it { expect(subject).to have_db_column(:parent_id) }
  it { expect(subject).to have_db_column(:name) }
  it { expect(subject).to have_db_column(:website) }
  it { expect(subject).to have_db_column(:created_at) }
  it { expect(subject).to have_db_column(:updated_at) }

  it { expect(subject).to belong_to(:category) }
  it { expect(subject).to belong_to(:parent) }
  it { expect(subject).to have_many(:children) }
  it { expect(subject).to have_and_belong_to_many(:projects) }
  it { expect(subject).to have_and_belong_to_many(:followers) }
  it { expect(subject).to have_and_belong_to_many(:likers) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_presence_of(:category) }

  describe '#projects' do
    it 'associates technology projects' do
      technology = create :technology
      project = create :project

      technology.projects << project
      technology.save
      technology.reload

      expect(technology.projects).to eq [project]
    end
  end

  describe '#skilled_people' do
    it 'associates person with technology' do
      technology = create :technology
      person_technology = create :person_technology, person: create(:person)

      technology.skilled_people << person_technology
      technology.save
      technology.reload

      expect(technology.skilled_people).to eq [person_technology]
    end
  end

  describe '#activities' do
    let(:technology) { create :technology }

    it 'associates person activities in decrescent publish order' do
      posts_a = create(:post)
      posts_b = create(:post)

      technology.activities.create item: posts_a, user: create(:user)
      technology.activities.create item: posts_b, user: create(:user)

      technology.reload

      expect(technology.activities).to have(2).items

      expect(technology.activities.first.item).to eq posts_b
      expect(technology.activities.second.item).to eq posts_a
    end
  end

  describe '#followers' do
    let(:technology) { create :technology }

    it 'user followed technology' do
      user = create :user

      user.followed_technologies << technology
      user.save
      user.reload
      technology.reload

      expect(technology.followers).to eq [user]
    end
  end

  describe '#likers' do
    let(:technology) { create :technology }

    it 'user liked technology' do
      user = create :user

      user.liked_technologies << technology
      user.save
      user.reload
      technology.reload

      expect(technology.likers).to eq [user]
    end
  end

  describe '#send_notification' do
    let(:technology) { create :technology }

    before do
      allow(technology).to receive(:send_notification)
    end

    it 'sends notification after saving' do
      expect(technology).to receive(:send_notification).exactly(2).times
      technology.name = 'some'
      technology.save
      technology.name = 'other'
      technology.save
    end

    it 'doesn\'t send notification after saving if there are no changes' do
      expect(technology).to receive(:send_notification).exactly(0).times
      technology.save
      technology.save
      technology.save
    end
  end

  describe 'technology hierarchy' do
    subject { create :technology }

    before do
      subject.children << create(:technology)
      subject.reload
    end

    it { expect(subject.children).to have(1).item }
    it { expect(subject.children.first).to be_kind_of(Technology) }
    it { expect(subject.children.first.parent).to eq(subject) }
  end
end
