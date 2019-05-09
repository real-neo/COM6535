# frozen_string_literal: true

# == Schema Information
#
# Table name: replies
#
#  id             :integer          not null, primary key
#  comment        :string
#  dislikes_count :integer          default(0)
#  likes_count    :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  original_id    :integer
#  post_id        :integer
#  user_id        :integer
#
# Indexes
#
#  index_replies_on_original_id  (original_id)
#  index_replies_on_post_id      (post_id)
#  index_replies_on_user_id      (user_id)
#

# Reply class
class Reply < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :user
  belongs_to :post

  has_many :likes, as: :likeable, dependent: :destroy

  belongs_to :original, class_name: 'Reply', optional: true

  def username
    user.username
  end

  def time_since_posted
    time_ago_in_words(self[:created_at]) + ' ago'
  end
end
