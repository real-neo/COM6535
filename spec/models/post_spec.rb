# == Schema Information
#
# Table name: posts
#
#  id          :integer          not null, primary key
#  description :string
#  dislikes    :integer
#  likes       :integer
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Post, type: :model do
  user = FactoryBot.create(:user)
  let(:post) { FactoryBot.create(:post, user: user)}

  it "is valid with valid attributes" do
    expect(post).to be_valid
  end

  it "is not valid without a title" do
    subject.title = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a description" do
    subject.description = nil
    expect(subject).to_not be_valid
  end


end
