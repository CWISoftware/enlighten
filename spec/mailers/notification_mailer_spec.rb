require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  describe 'instructions' do
    let(:entity) { create :technology }
    let(:follower) { create :user, :with_person }
    let(:mail) { NotificationMailer.notification_email(entity, follower) }

    it 'renders the subject' do
      expect(mail.subject).to match(entity.name)
    end

    it 'renders follower name in body' do
      expect(mail.body.encoded).to match(follower.person.name)
    end

    it 'renders entity name in body' do
      expect(mail.body.encoded).to match(entity.name)
    end
  end
end
