# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  city                   :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  firstname              :string
#  lastname               :string
#  location               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user)}

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  it "is not valid without a firstname" do
    subject.firstname = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a lastname" do
    subject.lastname = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a location" do
    subject.location=nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a city" do
    subject.city=nil
    expect(subject).to_not be_valid
  end

  it "is not valid without an email" do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a username" do
    subject.username = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a password" do
    subject.encrypted_password = nil
    expect(subject).to_not be_valid
  end
end
