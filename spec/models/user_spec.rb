# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  remember_token         :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it { expect(subject).to have_db_column(:id) }
  it { expect(subject).to have_db_column(:email) }
  it { expect(subject).to have_db_column(:encrypted_password) }
  it { expect(subject).to have_db_column(:reset_password_token) }
  it { expect(subject).to have_db_column(:reset_password_sent_at) }
  it { expect(subject).to have_db_column(:remember_token) }
  it { expect(subject).to have_db_column(:remember_created_at) }
  it { expect(subject).to have_db_column(:sign_in_count) }
  it { expect(subject).to have_db_column(:current_sign_in_at) }
  it { expect(subject).to have_db_column(:last_sign_in_at) }
  it { expect(subject).to have_db_column(:current_sign_in_ip) }
  it { expect(subject).to have_db_column(:last_sign_in_ip) }
  it { expect(subject).to have_db_column(:created_at) }
  it { expect(subject).to have_db_column(:updated_at) }

  it { expect(subject).to have_one(:person) }
  it { expect(subject).to have_and_belong_to_many(:followed_technologies) }
  it { expect(subject).to have_and_belong_to_many(:followed_projects) }
  it { expect(subject).to have_and_belong_to_many(:followed_clients) }
  it { expect(subject).to have_and_belong_to_many(:followed_people) }
  it { expect(subject).to have_and_belong_to_many(:followed_cards) }
  it { expect(subject).to have_and_belong_to_many(:liked_technologies) }
  it { expect(subject).to have_and_belong_to_many(:liked_projects) }
  it { expect(subject).to have_and_belong_to_many(:liked_clients) }
  it { expect(subject).to have_and_belong_to_many(:liked_people) }
  it { expect(subject).to have_and_belong_to_many(:liked_cards) }
  it { expect(subject).to have_and_belong_to_many(:permission_roles) }

  describe '#projects' do
    let(:project) { create :project }

    it 'user followed projects' do
      user = create :user

      user.followed_projects << project
      user.save
      user.reload

      expect(user.followed_projects).to eq [project]
    end

    it 'user liked projects' do
      user = create :user

      user.liked_projects << project
      user.save
      user.reload

      expect(user.liked_projects).to eq [project]
    end
  end

  describe '#technologies' do
    let(:technology) { create :technology }

    it 'user followed technologies' do
      user = create :user

      user.followed_technologies << technology
      user.save
      user.reload

      expect(user.followed_technologies).to eq [technology]
    end

    it 'user liked technologies' do
      user = create :user

      user.liked_technologies << technology
      user.save
      user.reload

      expect(user.liked_technologies).to eq [technology]
    end
  end

  describe '#clients' do
    let(:client) { create :client }

    it 'user followed clients' do
      user = create :user

      user.followed_clients << client
      user.save
      user.reload

      expect(user.followed_clients).to eq [client]
    end

    it 'user liked clients' do
      user = create :user

      user.liked_clients << client
      user.save
      user.reload

      expect(user.liked_clients).to eq [client]
    end
  end

  describe '#people' do
    let(:person) { create :person }

    it 'user followed people' do
      user = create :user

      user.followed_people << person
      user.save
      user.reload

      expect(user.followed_people).to eq [person]
    end

    it 'user liked people' do
      user = create :user

      user.liked_people << person
      user.save
      user.reload

      expect(user.liked_people).to eq [person]
    end
  end

  describe '#cards' do
    let(:card) { create :card }

    it 'user followed cards' do
      user = create :user

      user.followed_cards << card
      user.save
      user.reload

      expect(user.followed_cards).to eq [card]
    end

    it 'user liked cards' do
      user = create :user

      user.liked_cards << card
      user.save
      user.reload

      expect(user.liked_cards).to eq [card]
    end
  end

  describe '#ldap_attribute' do
    let(:user) { create(:user) }
    let(:attribute) { 'displayName' }

    subject { user.send(:ldap_attribute, attribute) }

    it 'receives ldap query parameter' do
      expect(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(user.email, attribute)
      subject
    end
  end

  describe '#creates_person_to_ldap_authentication' do
    let(:user) { create(:user) }

    subject { user.send(:creates_person_to_ldap_authentication) }

    context 'when ldap enabled' do
      let(:ldap_param) { ['xxx'] }

      before do
        allow(LDAP).to receive(:enabled?) { true }
        allow_any_instance_of(User).to receive(:ldap_attribute) { ldap_param }
        allow(Person).to receive(:create)
      end

      context 'when ldap have picture' do
        it 'receives StringIO image' do
          expect(StringIO).to receive(:new).exactly(2).times.with(ldap_param.first)
          subject
        end
      end

      context 'when ldap not have picture' do
        let(:ldap_param) { nil }

        it 'receives Gravatar image' do
          expect(Gravatar).to receive(:new).with(user.email) { double(image_data: nil) }
          subject
        end
      end
    end
  end

  describe '#assigns_default_permission_roles' do
    let(:permission_acls)  { [create(:permission_acl)] }
    let(:permission_roles) { create :permission_role, default: true, permission_acls: permission_acls }

    subject { create :user }

    context 'when have default roles' do
      before { permission_roles }

      it 'assign default permission roles' do
        expect(subject.permission_roles).to have(1).item
      end
    end
  end
end
