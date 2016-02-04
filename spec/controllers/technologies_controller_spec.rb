require 'rails_helper'

RSpec.describe TechnologiesController, type: :controller do
  let(:permission_acls) do
    [
      build(:permission_acl, model: 'technology', action: 'index'),
      build(:permission_acl, model: 'technology', action: 'show'),
      build(:permission_acl, model: 'technology', action: 'new'),
      build(:permission_acl, model: 'technology', action: 'edit'),
      build(:permission_acl, model: 'technology', action: 'create'),
      build(:permission_acl, model: 'technology', action: 'update'),
      build(:permission_acl, model: 'technology', action: 'destroy'),
      build(:permission_acl, model: 'technology', action: 'unfollow'),
      build(:permission_acl, model: 'technology', action: 'follow'),
      build(:permission_acl, model: 'technology', action: 'unlike'),
      build(:permission_acl, model: 'technology', action: 'like')
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
    it 'assigns @technologies' do
      create_list(:technology, 10)
      get :cards, format: :json
      expect(JSON.parse(response.body).count).to eq(10)
    end
  end

  describe 'GET #card' do
    before do
      @technology = create :technology
    end

    it 'renders the :card serialized' do
      get :card, id: @technology.card.id, format: :json
      expect(assigns(:card)).to eq(@technology.card)
    end
  end

  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'GET #edit' do
    before do
      @technology = create :technology
    end

    it 'assigns the requested technology to @technology' do
      get :edit, id: @technology.id
      expect(assigns(:technology)).to eq(@technology)
    end

    it 'renders the :edit template' do
      get :edit, id: @technology.id
      expect(response).to render_template('edit')
    end
  end

  describe 'GET #show' do
    before do
      @technology = create :technology
    end

    it 'assigns the requested technology to @technology' do
      get :show, id: @technology.id
      expect(assigns(:technology)).to eq(@technology)
    end

    it 'renders the :show template' do
      get :show, id: @technology.id
      expect(response).to render_template('show')
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:image_file) { fixture_file_upload('files/300x300.gif', 'image/gif') }

      it 'saves the new technology in the database' do
        expect do
          post :create, technology: attributes_for(:technology,
                                                   image: image_file,
                                                   technology_category_id: create(:technology_category).id)
        end.to change(Technology, :count).by(1)
      end

      it 'redirects to the technology #show' do
        post :create, technology: attributes_for(:technology,
                                                 technology_category_id: create(:technology_category).id)

        expect(response).to redirect_to(assigns(:technology))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new technology in the database' do
        expect do
          post :create, technology: attributes_for(:invalid_technology)
        end.to_not change(Technology, :count)
      end

      it 're-renders the :new template' do
        post :create, technology: attributes_for(:invalid_technology)
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    before do
      @technology = create :technology
    end

    context 'with valid attributes' do
      let(:image_file) { fixture_file_upload('files/300x300.gif', 'image/gif') }

      it 'assigns the requested technology to @technology' do
        put :update, id: @technology.id, technology: attributes_for(:technology, image: image_file)
        expect(assigns(:technology)).to eq(@technology)
      end

      it 'changes the @technology attributes' do
        put :update, id: @technology, technology: attributes_for(:technology, name: 'updated-name', image: image_file)
        @technology.reload
        expect(@technology.name).to eq 'updated-name'
      end

      it 'redirects to the updated technology' do
        put :update, id: @technology, technology: attributes_for(:technology, name: 'updated-name', image: image_file)
        expect(response).to redirect_to(@technology)
      end
    end

    context 'with invalid attributes' do
      it 'assigns the requested technology to @technology' do
        put :update, id: @technology.id, technology: attributes_for(:invalid_technology)
        expect(assigns(:technology)).to eq(@technology)
      end

      it 'does not change the @technology attributes' do
        expect do
          put :update, id: @technology, technology: attributes_for(:invalid_technology)
          @technology.reload
        end.to_not change(@technology, :name)
      end

      it 're-renders the :edit template' do
        put :update, id: @technology, technology: attributes_for(:invalid_technology)
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @technology = create :technology
    end

    it 'deletes the technology' do
      expect { delete :destroy, id: @technology.id }.to change(Technology, :count).by(-1)
    end

    it 'redirects to technology index' do
      delete :destroy, id: @technology.id
      expect(response).to redirect_to(technologies_url)
    end
  end

  describe 'PUT #follow' do
    let(:technology) { create :technology }

    subject { put :follow, id: technology.id }

    it 'current user follow technology' do
      subject
      technology.reload

      expect(technology.followers).to include(current_user)
      expect(response).to redirect_to(technology)
    end

    it 'current user try follow already followed technology' do
      technology.followers << current_user

      subject
      technology.reload

      expect(controller.current_user).not_to receive(:save)
      expect(technology.followers).to eq [current_user]
      expect(response).to redirect_to(technology)
    end
  end

  describe 'PUT #unfollow' do
    let(:technology) { create :technology }

    subject { put :unfollow, id: technology.id }

    it 'current user already unfollowed technology' do
      technology.followers << current_user

      expect(controller.current_user.followed_technologies).to receive(:delete)
      expect(controller.current_user).to receive(:save)

      subject
    end

    it 'current user unfollow technology' do
      technology.followers << current_user

      subject
      technology.reload

      expect(technology.followers).to eq []
      expect(response).to redirect_to(technology)
    end
  end

  describe 'PUT #like' do
    let(:technology) { create :technology }

    subject { put :like, id: technology.id }

    it 'current user like technology' do
      subject
      technology.reload

      expect(technology.likers).to include(current_user)
      expect(response).to redirect_to(technology)
    end

    it 'current user try like already liked technology' do
      technology.likers << current_user

      subject
      technology.reload

      expect(controller.current_user).not_to receive(:save)
      expect(technology.likers).to eq [current_user]
      expect(response).to redirect_to(technology)
    end
  end

  describe 'PUT #unlike' do
    let(:technology) { create :technology }

    subject { put :unlike, id: technology.id }

    it 'current user already liked technology' do
      technology.likers << current_user

      expect(controller.current_user.liked_technologies).to receive(:delete)
      expect(controller.current_user).to receive(:save)

      subject
    end

    it 'current user unlike technology' do
      technology.likers << current_user

      subject
      technology.reload

      expect(technology.likers).to eq []
      expect(response).to redirect_to(technology)
    end
  end
end
