# frozen_string_literal: true

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

# Like class
class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true
  belongs_to :user


  scope :like, -> { where(like: true) }
  scope :dislike, -> { where(like: false) }

  scope :count_likes, -> { where(like: true).count }
  scope :count_dislikes, -> { where(like: false).count }

  validate :check_app_likes

  private

  def check_app_likes
    if likeable_type == 'Post' && Post.find(likeable.id).post_type == 'App'
    # elsif likeable_type == 'Reply' && Reply.find(likeable.id).post_type == 'App'
      errors.add(:post, 'can not be App post.')
    end
  end
end
