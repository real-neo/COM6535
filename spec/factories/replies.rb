# == Schema Information
#
# Table name: replies
#
#  id          :integer          not null, primary key
#  comment     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  original_id :integer
#  post_id     :integer
#  user_id     :integer
#
# Indexes
#
#  index_replies_on_original_id  (original_id)
#  index_replies_on_post_id      (post_id)
#  index_replies_on_user_id      (user_id)
#

FactoryBot.define do
  factory :reply do
    comment { "MyString" }
    user { nil }
    post { nil }
    original { nil }
  end
end
