# == Schema Information
#
# Table name: ratings
#
#  id         :integer          not null, primary key
#  star       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  user_id    :integer
#
# Indexes
#
#  index_ratings_on_post_id  (post_id)
#  index_ratings_on_user_id  (user_id)
#

FactoryBot.define do
  factory :rating do
    
  end
end
