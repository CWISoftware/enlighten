# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  name            :string
#  github_account  :string
#  twitter_account :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Person, type: :model do
  it { expect(subject).to have_db_column(:id) }
  it { expect(subject).to have_db_column(:user_id) }
  it { expect(subject).to have_db_column(:name) }
  it { expect(subject).to have_db_column(:github_account) }
  it { expect(subject).to have_db_column(:twitter_account) }
  it { expect(subject).to have_db_column(:created_at) }
  it { expect(subject).to have_db_column(:updated_at) }
end