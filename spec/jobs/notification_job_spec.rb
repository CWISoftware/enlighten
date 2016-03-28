require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  describe '#perform' do
    let(:technology) do
      create(:technology, followers: [
               create(:user, person: create(:person)),
               create(:user, person: create(:person)),
               create(:user, person: create(:person, :without_notification)),
               create(:user, person: create(:person, :without_notification))
             ])
    end
    let(:mailer) { double deliver_later: nil }

    before do
      allow(NotificationMailer).to receive(:notification_email) { mailer }
    end

    subject { described_class.perform_now(technology) }

    it 'sends email for people with notification enabled' do
      expect(mailer).to receive(:deliver_later).exactly(2).times
      subject
    end
  end
end
