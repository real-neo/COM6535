# frozen_string_literal: true
# == Schema Information
#
# Table name: posts
#
#  id             :integer          not null, primary key
#  description    :string
#  dislikes_count :integer          default(0)
#  likes_count    :integer          default(0)
#  post_type      :integer
#  rating         :float
#  replies_count  :integer          default(0)
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Post, type: :model do
  user = FactoryBot.create(:user)
  let(:post) { FactoryBot.create(:post, user: user) }

  it 'is valid with valid attributes' do
    expect(post).to be_valid
  end

  it 'is not valid without a title' do
    post.title = nil
    expect(post).to_not be_valid
  end

  it 'is not valid without a description' do
    post.description = nil
    expect(post).to_not be_valid
  end

  it 'is not valid without a description' do
    post.post_type = nil
    expect(post).to_not be_valid
  end
end
