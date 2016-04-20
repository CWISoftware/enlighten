# == Schema Information
#
# Table name: card_attachments
#
#  id            :integer          not null, primary key
#  card_id       :integer
#  attachment_id :string
#

require 'rails_helper'

RSpec.describe CardAttachment, type: :model do
  it { expect(subject).to belong_to(:card) }
end
