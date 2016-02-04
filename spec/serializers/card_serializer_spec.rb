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

RSpec.describe CardSerializer, type: :serializer do
  let(:helpers) { ApplicationController.helpers }
  let(:user)    { create(:user) }
  let(:card)    { create(:person).card }

  subject { described_class.new(card) }

  before do
    allow(subject).to receive(:helpers) { helpers }
    allow(subject).to receive(:scope) { user }
  end

  context '.size' do
    it { expect(subject.size).to eq(3) }
  end

  context '.likable_total' do
    context "when isen't likable" do
      before { allow(subject).to receive(:likable?) { false } }

      it 'returns zero' do
        expect(subject.send(:likable_total)).to be_zero
      end
    end

    context 'when is likable' do
      it 'receive likers count' do
        expect(card.cardable).to receive(:likers) { double(count: 0) }
        subject.send(:likable_total)
      end
    end
  end

  context '.likable_icon' do
    context "when isen't likable" do
      before { allow(subject).to receive(:likable?) { false } }

      it 'returns nil' do
        expect(subject.send(:likable_icon)).to be_nil
      end
    end

    context 'when is likable' do
      context 'when already liked' do
        before { allow(subject).to receive(:liked?) { true } }

        it 'receive image_url' do
          expect(helpers).to receive(:image_url).with('icons/cards/icn-likers-selected.svg')
          subject.send(:likable_icon)
        end
      end

      context 'when not liked yet' do
        before { allow(subject).to receive(:liked?) { false } }

        it 'receive image_url' do
          expect(helpers).to receive(:image_url).with('icons/cards/icn-likers.svg')
          subject.send(:likable_icon)
        end
      end
    end
  end

  context '.likable_path' do
    context "when isen't likable" do
      before { allow(subject).to receive(:likable?) { false } }

      it 'returns nil' do
        expect(subject.send(:likable_path)).to be_nil
      end
    end

    context 'when is likable' do
      let(:liked) { false }

      before { allow(subject).to receive(:liked?) { liked } }

      context 'when not liked yet' do
        it 'receives like path' do
          expect(subject).to receive(:polymorphic_path).with(card.cardable, action: :like, format: :json)
          subject.send(:likable_path)
        end
      end

      context 'when already liked' do
        let(:liked) { true }

        it 'receives unlike path' do
          expect(subject).to receive(:polymorphic_path).with(card.cardable, action: :unlike, format: :json)
          subject.send(:likable_path)
        end
      end
    end
  end

  context '.likable_method_name'do
    it 'receives likable method name' do
      expect(subject.send(:likable_method_name)).to eq(:liked_people)
    end
  end

  context '.likable?' do
    it 'receives current user test if respond to' do
      expect(user).to receive(:respond_to?).with(:liked_people)
      subject.send(:likable?)
    end
  end

  context '.liked?' do
    it 'receives if current user already like model' do
      expect(user).to receive(:send).with(:liked_people) { double(include?: nil) }
      subject.send(:liked?)
    end
  end

  context '.followable_total' do
    context "when isen't followable" do
      before { allow(subject).to receive(:followable?) { false } }

      it 'returns zero' do
        expect(subject.send(:followable_total)).to be_zero
      end
    end

    context 'when is followable' do
      it 'receive followers count' do
        expect(card.cardable).to receive(:followers) { double(count: 0) }
        subject.send(:followable_total)
      end
    end
  end

  context '.followable_icon' do
    context "when isen't followable" do
      before { allow(subject).to receive(:followable?) { false } }

      it 'returns nil' do
        expect(subject.send(:followable_icon)).to be_nil
      end
    end

    context 'when is followable' do
      context 'when already followed' do
        before { allow(subject).to receive(:followed?) { true } }

        it 'receive image_url' do
          expect(helpers).to receive(:image_url).with('icons/cards/icn-followers-selected.svg')
          subject.send(:followable_icon)
        end
      end

      context 'when not followed yet' do
        before { allow(subject).to receive(:followed?) { false } }

        it 'receive image_url' do
          expect(helpers).to receive(:image_url).with('icons/cards/icn-followers.svg')
          subject.send(:followable_icon)
        end
      end
    end
  end

  context '.followable_path' do
    context "when isen't followable" do
      before { allow(subject).to receive(:followable?) { false } }

      it 'returns nil' do
        expect(subject.send(:followable_path)).to be_nil
      end
    end

    context 'when is followable' do
      let(:followed) { false }

      before { allow(subject).to receive(:followed?) { followed } }

      context 'when not followed yet' do
        it 'receives follow path' do
          expect(subject).to receive(:polymorphic_path).with(card.cardable, action: :follow, format: :json)
          subject.send(:followable_path)
        end
      end

      context 'when already followed' do
        let(:followed) { true }

        it 'receives unfollow path' do
          expect(subject).to receive(:polymorphic_path).with(card.cardable, action: :unfollow, format: :json)
          subject.send(:followable_path)
        end
      end
    end
  end

  context '.followable_method_name'do
    it 'receives followable method name' do
      expect(subject.send(:followable_method_name)).to eq(:followed_people)
    end
  end

  context '.followable?' do
    it 'receives current user test if respond to' do
      expect(user).to receive(:respond_to?).with(:followed_people)
      subject.send(:followable?)
    end
  end

  context '.followed?' do
    it 'receives if current user already follow model' do
      expect(user).to receive(:send).with(:followed_people) { double(include?: nil) }
      subject.send(:followed?)
    end
  end

  context '.model' do
    context 'when have a cardable entity' do
      it 'receives entity' do
        expect(subject.send(:model)).to eq(card.cardable)
      end
    end

    context "when don't have a cardable entity" do
      let(:card) { create(:card) }

      it 'receives card entity' do
        expect(subject.send(:model)).to eq(card)
      end
    end
  end

  context '.helpers' do
    it 'receives application helpers' do
      expect(ApplicationController).to receive(:helpers)
      subject.send(:helpers)
    end
  end

  context '.current_user' do
    it 'receives scope' do
      expect(subject).to receive(:scope)
      subject.send(:current_user)
    end
  end

  context 'when have a cardable entity' do
    let(:card) { create(:person).card }

    context '.avatar' do
      it 'call attachment from entity' do
        expect(helpers).to receive(:attachment_url)
        subject.avatar
      end
    end

    context '.links' do
      it 'generates links to card' do
        expect(subject.links).to include(:self)
        expect(subject.links).to include(:cardable)
        expect(subject.links).to include(:likable)
        expect(subject.links).to include(:followable)
      end
    end

    context '.statistics' do
      it 'generates statistics to card' do
        expect(subject.statistics).to have(2).items
      end
    end
  end

  context 'have attributes' do
    let(:card) { create(:person).card }

    it 'receives keys' do
      expect(subject.attributes).to include(:id)
      expect(subject.attributes).to include(:section)
      expect(subject.attributes).to include(:title)
      expect(subject.attributes).to include(:subtitle)
      expect(subject.attributes).to include(:description)
      expect(subject.attributes).to include(:avatar)
      expect(subject.attributes).to include(:links)
      expect(subject.attributes).to include(:style)
      expect(subject.attributes).to include(:size)
      expect(subject.attributes).to include(:statistics)
      expect(subject.attributes).to include(:attachments)
      expect(subject.attributes).to include(:galleries)
    end
  end
end
