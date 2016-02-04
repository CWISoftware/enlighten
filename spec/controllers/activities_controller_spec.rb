require 'rails_helper'

RSpec.describe ActivitiesController, type: :controller do
  let(:permission_acls) do
    [
      build(:permission_acl, model: 'activity', action: 'create')
    ]
  end
  let(:permission_roles) { [double(permission_acls: permission_acls)] }
  let(:current_user)     { create :user }

  before do
    sign_in current_user
    allow(controller).to receive(:authenticate_user!) { true }
    allow(controller.current_user).to receive(:permission_roles) { permission_roles }
  end

  shared_examples 'create activity' do
    context 'with valid activity attributes' do
      let(:request_data) do
        { type: type }
          .merge(activity_owner_data)
          .merge(activity_data)
      end

      it 'saves the new post in the database for the person' do
        activity_owner_model = activity_owner.class

        expect do
          post :create, **request_data
        end.to change { activity_owner_model.find(activity_owner.id).activities.where(item_type: type.capitalize).count }.by(1)
      end

      it 'returns the new post data' do
        returned_post_data = JSON.parse post(:create, **request_data).body

        expect(returned_post_data).to have_key 'id'
        expect(returned_post_data['id']).to be_an Integer
      end
    end

    context 'with invalid activity attributes' do
      let(:request_data) do
        { type: type, format: 'json' }
          .merge(activity_owner_data)
          .merge(invalid_activity_data)
      end

      it 'returns the model validation errors' do
        returned_post_data = JSON.parse post(:create, **request_data).body

        expect(returned_post_data).to eq('item' => [I18n.t(:"errors.messages.blank")])
      end
    end
  end

  describe 'POST #create' do

    context 'when type is post' do
      let(:type) { 'post' }
      let(:activity_data) { { post: attributes_for(:post) } }
      let(:invalid_activity_data) { { post: attributes_for(:post, body: '') } }

      context 'when owner is person' do
        let(:activity_owner) { create :person }
        let(:activity_owner_data) { { owner: 'person', person_id: activity_owner.id } }

        it_behaves_like 'create activity'
      end

      context 'when owner is project' do
        let(:activity_owner) { create :project }
        let(:activity_owner_data) { { owner: 'project', project_id: activity_owner.id } }

        it_behaves_like 'create activity'
      end

      context 'when owner is technology' do
        let(:activity_owner) { create :technology }
        let(:activity_owner_data) { { owner: 'technology', technology_id: activity_owner.id } }

        it_behaves_like 'create activity'
      end
    end
  end
end
