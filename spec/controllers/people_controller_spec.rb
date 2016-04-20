require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  let(:permission_acls) do
    [
      build(:permission_acl, model: 'person', action: 'index'),
      build(:permission_acl, model: 'person', action: 'show'),
      build(:permission_acl, model: 'person', action: 'new'),
      build(:permission_acl, model: 'person', action: 'edit'),
      build(:permission_acl, model: 'person', action: 'create'),
      build(:permission_acl, model: 'person', action: 'update'),
      build(:permission_acl, model: 'person', action: 'destroy'),
      build(:permission_acl, model: 'person', action: 'unfollow'),
      build(:permission_acl, model: 'person', action: 'follow'),
      build(:permission_acl, model: 'person', action: 'unlike'),
      build(:permission_acl, model: 'person', action: 'like')
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
    it 'assigns @people' do
      create_list(:person, 10)
      get :cards, format: :json
      expect(JSON.parse(response.body).count).to eq(10)
    end
  end

  describe 'GET #card' do
    before do
      @person = create :person
    end

    it 'renders the :card serialized' do
      get :card, id: @person.card.id, format: :json
      expect(assigns(:card)).to eq(@person.card)
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
      @person = create :person
    end

    it 'assigns the requested person to @person' do
      get :edit, id: @person.id
      expect(assigns(:person)).to eq(@person)
    end

    it 'renders the :edit template' do
      get :edit, id: @person.id
      expect(response).to render_template('edit')
    end
  end

  describe 'GET #show' do
    before do
      @person = create :person
    end

    it 'assigns the requested person to @person' do
      get :show, id: @person.id
      expect(assigns(:person)).to eq(@person)
    end

    it 'renders the :show template' do
      get :show, id: @person.id
      expect(response).to render_template('show')
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:image_file) { fixture_file_upload('files/300x300.gif', 'image/gif') }

      it 'saves the new person in the database' do
        expect do
          post :create, person: attributes_for(:person, image: image_file)
        end.to change(Person, :count).by(1)
      end

      it 'redirects to the person #show' do
        post :create, person: attributes_for(:person)
        expect(response).to redirect_to(assigns(:person))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new person in the database' do
        expect do
          post :create, person: attributes_for(:invalid_person)
        end.to_not change(Person, :count)
      end

      it 're-renders the :new template' do
        post :create, person: attributes_for(:invalid_person)
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    before do
      @person = create :person
    end

    context 'with valid attributes' do
      let(:image_file) { fixture_file_upload('files/300x300.gif', 'image/gif') }

      it 'assigns the requested person to @person' do
        put :update, id: @person.id, person: attributes_for(:person, image: image_file)
        expect(assigns(:person)).to eq(@person)
      end

      it 'changes the @person attributes' do
        put :update, id: @person, person: attributes_for(:person, name: 'updated-name', image: image_file)
        @person.reload
        expect(@person.name).to eq 'updated-name'
      end

      it 'redirects to the updated person' do
        put :update, id: @person, person: attributes_for(:person, name: 'updated-name', image: image_file)
        expect(response).to redirect_to(@person)
      end
    end

    context 'with invalid attributes' do
      it 'assigns the requested person to @person' do
        put :update, id: @person.id, person: attributes_for(:invalid_person)
        expect(assigns(:person)).to eq(@person)
      end

      it 'does not change the @person attributes' do
        expect do
          put :update, id: @person, person: attributes_for(:invalid_person)
          @person.reload
        end.to_not change(@person, :name)
      end

      it 're-renders the :edit template' do
        put :update, id: @person, person: attributes_for(:invalid_person)
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @person = create :person
    end

    it 'deletes the person' do
      expect { delete :destroy, id: @person.id }.to change(Person, :count).by(-1)
    end

    it 'redirects to person index' do
      delete :destroy, id: @person.id
      expect(response).to redirect_to(people_url)
    end
  end

  describe 'PUT #follow' do
    let(:person) { create :person }

    subject { put :follow, id: person.id }

    it 'current user follow person' do
      subject
      person.reload

      expect(person.followers).to include(current_user)
      expect(response).to redirect_to(person)
    end

    it 'current user try follow already followed person' do
      person.followers << current_user

      subject
      person.reload

      expect(controller.current_user).not_to receive(:save)
      expect(person.followers).to eq [current_user]
      expect(response).to redirect_to(person)
    end
  end

  describe 'PUT #unfollow' do
    let(:person) { create :person }

    subject { put :unfollow, id: person.id }

    it 'current user already unfollowed person' do
      person.followers << current_user

      expect(controller.current_user.followed_people).to receive(:delete)
      expect(controller.current_user).to receive(:save)

      subject
    end

    it 'current user unfollow person' do
      person.followers << current_user

      subject
      person.reload

      expect(person.followers).to eq []
      expect(response).to redirect_to(person)
    end
  end

  describe 'PUT #like' do
    let(:person) { create :person }

    subject { put :like, id: person.id }

    it 'current user like person' do
      subject
      person.reload

      expect(person.likers).to include(current_user)
      expect(response).to redirect_to(person)
    end

    it 'current user try like already liked person' do
      person.likers << current_user

      subject
      person.reload

      expect(controller.current_user).not_to receive(:save)
      expect(person.likers).to eq [current_user]
      expect(response).to redirect_to(person)
    end
  end

  describe 'PUT #unlike' do
    let(:person) { create :person }

    subject { put :unlike, id: person.id }

    it 'current user already liked person' do
      person.likers << current_user

      expect(controller.current_user.liked_people).to receive(:delete)
      expect(controller.current_user).to receive(:save)

      subject
    end

    it 'current user unlike person' do
      person.likers << current_user

      subject
      person.reload

      expect(person.likers).to eq []
      expect(response).to redirect_to(person)
    end
  end
end
