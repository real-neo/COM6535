# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  like       :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  user_id    :integer
#
# Indexes
#
#  index_likes_on_post_id  (post_id)
#  index_likes_on_user_id  (user_id)
#

class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  scope :like, -> { where(like: true) }
  scope :dislike, -> { where(like: false) }

  scope :count_likes, -> { where(like: true).count }
  scope :count_dislikes, -> { where(like: false).count }
end
