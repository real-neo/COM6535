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

FactoryBot.define do
  factory :post do
    title { 'My Title' }
    description { 'My Description' }
    post_type { 0 }
  end
end
