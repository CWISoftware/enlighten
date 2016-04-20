require 'rails_helper'

RSpec.describe CardsController, type: :controller do
  let(:permission_acls) do
    [
      build(:permission_acl, model: 'card', action: 'index'),
      build(:permission_acl, model: 'card', action: 'cards'),
      build(:permission_acl, model: 'card', action: 'card'),
      build(:permission_acl, model: 'card', action: 'follow'),
      build(:permission_acl, model: 'card', action: 'unfollow'),
      build(:permission_acl, model: 'card', action: 'like'),
      build(:permission_acl, model: 'card', action: 'unlike')
    ]
  end
  let(:permission_roles) { [double(permission_acls: permission_acls)] }
  let(:current_user)     { create :user }

  before do
    sign_in current_user
    allow(controller).to receive(:authenticate_user!) { true }
    allow(controller.current_user).to receive(:permission_roles) { permission_roles }
  end

  describe 'GET #index' do
    it 'renders the :index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #cards' do
    it 'assigns @cards' do
      create_list(:card, 10)
      get :cards, format: :json
      expect(JSON.parse(response.body).count).to eq(10)
    end
  end

  describe 'GET #card' do
    before do
      @card = create :card
    end

    it 'renders the :card serialized' do
      get :card, id: @card.id, format: :json
      expect(assigns(:card)).to eq(@card)
    end
  end

  describe 'PUT #follow' do
    let(:card) { create :card }

    subject { put :follow, id: card.id }

    it 'current user follow card' do
      subject
      card.reload

      expect(card.followers).to include(current_user)
      expect(response).to redirect_to(card)
    end

    it 'current user try follow already followed card' do
      card.followers << current_user

      subject
      card.reload

      expect(controller.current_user).not_to receive(:save)
      expect(card.followers).to eq [current_user]
      expect(response).to redirect_to(card)
    end
  end

  describe 'PUT #unfollow' do
    let(:card) { create :card }

    subject { put :unfollow, id: card.id }

    it 'current user already unfollowed card' do
      card.followers << current_user

      expect(controller.current_user.followed_cards).to receive(:delete)
      expect(controller.current_user).to receive(:save)

      subject
    end

    it 'current user unfollow card' do
      card.followers << current_user

      subject
      card.reload

      expect(card.followers).to eq []
      expect(response).to redirect_to(card)
    end
  end

  describe 'PUT #like' do
    let(:card) { create :card }

    subject { put :like, id: card.id }

    it 'current user like card' do
      subject
      card.reload

      expect(card.likers).to include(current_user)
      expect(response).to redirect_to(card)
    end

    it 'current user try like already liked card' do
      card.likers << current_user

      subject
      card.reload

      expect(controller.current_user).not_to receive(:save)
      expect(card.likers).to eq [current_user]
      expect(response).to redirect_to(card)
    end
  end

  describe 'PUT #unlike' do
    let(:card) { create :card }

    subject { put :unlike, id: card.id }

    it 'current user already liked card' do
      card.likers << current_user

      expect(controller.current_user.liked_cards).to receive(:delete)
      expect(controller.current_user).to receive(:save)

      subject
    end

    it 'current user unlike card' do
      card.likers << current_user

      subject
      card.reload

      expect(card.likers).to eq []
      expect(response).to redirect_to(card)
    end
  end
end
