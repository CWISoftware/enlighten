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

require 'rails_helper'

RSpec.describe Card, type: :model do
  it { expect(subject).to have_many(:galleries) }
  it { expect(subject).to have_many(:attachments) }
  it { expect(subject).to belong_to(:cardable) }
  it { expect(subject).to have_and_belong_to_many(:followers) }
  it { expect(subject).to have_and_belong_to_many(:likers) }

  describe '#followers' do
    let(:card) { create :card }

    it 'user followed cards' do
      user = create :user

      user.followed_cards << card
      user.save
      user.reload
      card.reload

      expect(card.followers).to eq [user]
    end
  end

  describe '#likers' do
    let(:card) { create :card }

    it 'user liked cards' do
      user = create :user

      user.liked_cards << card
      user.save
      user.reload
      card.reload

      expect(card.likers).to eq [user]
    end
  end
end
