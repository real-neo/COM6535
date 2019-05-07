# frozen_string_literal: true

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

# Like class
class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  scope :like, -> { where(like: true) }
  scope :dislike, -> { where(like: false) }

  scope :count_likes, -> { where(like: true).count }
  scope :count_dislikes, -> { where(like: false).count }

  validate :check_app_likes

  private

  def check_app_likes
    errors.add(:post, 'can not be App post.') if post.post_type == 'App'
  end
end
