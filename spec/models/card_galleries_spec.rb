# == Schema Information
#
# Table name: card_galleries
#
#  id            :integer          not null, primary key
#  card_id       :integer
#  timeout       :integer
#  order         :integer
#  attachment_id :string
#

require 'rails_helper'

RSpec.describe CardGallery, type: :model do
  it { expect(subject).to belong_to(:card) }
end
