# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  like          :boolean
#  likeable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  likeable_id   :integer
#  user_id       :integer
#
# Indexes
#
#  index_likes_on_likeable_type_and_likeable_id  (likeable_type,likeable_id)
#  index_likes_on_user_id                        (user_id)
#

FactoryBot.define do
  factory :like do
    like { true }
  end
end
