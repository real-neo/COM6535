# == Schema Information
#
# Table name: posts
#
#  id          :integer          not null, primary key
#  description :string
#  post_type   :integer
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
  end
end
