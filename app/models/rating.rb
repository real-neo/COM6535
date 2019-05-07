# frozen_string_literal: true

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

# Rating class
class Rating < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :star, presence: true
  validates :star, numericality: { only_integer: true, greater_than: 0, less_than: 6 }

  validate :check_non_app_ratings

  private

  def check_non_app_ratings
    errors.add(:post, 'can not be non-App post.') if post.post_type != 'App'
  end
end
