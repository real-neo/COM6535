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

FactoryBot.define do
  factory :post do
    title { "My Title" }
    description { "My Description" }
    likes { 1 }
    dislikes { 1 }
    user { nil }
  end
end
