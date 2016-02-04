require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  let(:permission_acls) do
    [
      build(:permission_acl, model: 'client', action: 'index'),
      build(:permission_acl, model: 'client', action: 'show'),
      build(:permission_acl, model: 'client', action: 'new'),
      build(:permission_acl, model: 'client', action: 'edit'),
      build(:permission_acl, model: 'client', action: 'create'),
      build(:permission_acl, model: 'client', action: 'update'),
      build(:permission_acl, model: 'client', action: 'destroy'),
      build(:permission_acl, model: 'client', action: 'unfollow'),
      build(:permission_acl, model: 'client', action: 'follow'),
      build(:permission_acl, model: 'client', action: 'unlike'),
      build(:permission_acl, model: 'client', action: 'like')
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
    it 'assigns @clients' do
      create_list(:client, 10)
      get :cards, format: :json
      expect(JSON.parse(response.body).count).to eq(10)
    end
  end

  describe 'GET #card' do
    before do
      @client = create :client
    end

    it 'renders the :card serialized' do
      get :card, id: @client.card.id, format: :json
      expect(assigns(:card)).to eq(@client.card)
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
      @client = create :client
    end

    it 'assigns the requested client to @client' do
      get :edit, id: @client.id
      expect(assigns(:client)).to eq(@client)
    end

    it 'renders the :edit template' do
      get :edit, id: @client.id
      expect(response).to render_template('edit')
    end
  end

  describe 'GET #show' do
    before do
      @client = create :client
    end

    it 'assigns the requested client to @client' do
      get :show, id: @client.id
      expect(assigns(:client)).to eq(@client)
    end

    it 'renders the :show template' do
      get :show, id: @client.id
      expect(response).to render_template('show')
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:image_file) { fixture_file_upload('files/300x300.gif', 'image/gif') }

      it 'saves the new client in the database' do
        expect do
          post :create, client: attributes_for(:client, image: image_file)
        end.to change(Client, :count).by(1)
      end

      it 'redirects to the client #show' do
        post :create, client: attributes_for(:client)
        expect(response).to redirect_to(assigns(:client))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new client in the database' do
        expect do
          post :create, client: attributes_for(:invalid_client)
        end.to_not change(Client, :count)
      end

      it 're-renders the :new template' do
        post :create, client: attributes_for(:invalid_client)
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    before do
      @client = create :client
    end

    context 'with valid attributes' do
      let(:image_file) { fixture_file_upload('files/300x300.gif', 'image/gif') }

      it 'assigns the requested client to @client' do
        put :update, id: @client.id, client: attributes_for(:client, image: image_file)
        expect(assigns(:client)).to eq(@client)
      end

      it 'changes the @client attributes' do
        put :update, id: @client, client: attributes_for(:client, name: 'updated-name', image: image_file)
        @client.reload
        expect(@client.name).to eq 'updated-name'
      end

      it 'redirects to the updated client' do
        put :update, id: @client, client: attributes_for(:client, name: 'updated-name', image: image_file)
        expect(response).to redirect_to(@client)
      end
    end

    context 'with invalid attributes' do
      it 'assigns the requested client to @client' do
        put :update, id: @client.id, client: attributes_for(:invalid_client)
        expect(assigns(:client)).to eq(@client)
      end

      it 'does not change the @client attributes' do
        expect do
          put :update, id: @client, client: attributes_for(:invalid_client)
          @client.reload
        end.to_not change(@client, :name)
      end

      it 're-renders the :edit template' do
        put :update, id: @client, client: attributes_for(:invalid_client)
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @client = create :client
    end

    it 'deletes the client' do
      expect { delete :destroy, id: @client.id }.to change(Client, :count).by(-1)
    end

    it 'redirects to client index' do
      delete :destroy, id: @client.id
      expect(response).to redirect_to(clients_url)
    end
  end

  describe 'PUT #follow' do
    let(:client) { create :client }

    subject { put :follow, id: client.id }

    it 'current user follow client' do
      subject
      client.reload

      expect(client.followers).to include(current_user)
      expect(response).to redirect_to(client)
    end

    it 'current user try follow already followed client' do
      client.followers << current_user

      subject
      client.reload

      expect(controller.current_user).not_to receive(:save)
      expect(client.followers).to eq [current_user]
      expect(response).to redirect_to(client)
    end
  end

  describe 'PUT #unfollow' do
    let(:client) { create :client }

    subject { put :unfollow, id: client.id }

    it 'current user already unfollowed client' do
      client.followers << current_user

      expect(controller.current_user.followed_clients).to receive(:delete)
      expect(controller.current_user).to receive(:save)

      subject
    end

    it 'current user unfollow client' do
      client.followers << current_user

      subject
      client.reload

      expect(client.followers).to eq []
      expect(response).to redirect_to(client)
    end
  end

  describe 'PUT #like' do
    let(:client) { create :client }

    subject { put :like, id: client.id }

    it 'current user like client' do
      subject
      client.reload

      expect(client.likers).to include(current_user)
      expect(response).to redirect_to(client)
    end

    it 'current user try like already liked client' do
      client.likers << current_user

      subject
      client.reload

      expect(controller.current_user).not_to receive(:save)
      expect(client.likers).to eq [current_user]
      expect(response).to redirect_to(client)
    end
  end

  describe 'PUT #unlike' do
    let(:client) { create :client }

    subject { put :unlike, id: client.id }

    it 'current user already liked client' do
      client.likers << current_user

      expect(controller.current_user.liked_clients).to receive(:delete)
      expect(controller.current_user).to receive(:save)

      subject
    end

    it 'current user unlike client' do
      client.likers << current_user

      subject
      client.reload

      expect(client.likers).to eq []
      expect(response).to redirect_to(client)
    end
  end
end
