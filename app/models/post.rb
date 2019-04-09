# frozen_string_literal: true

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

# Post class
class Post < ApplicationRecord
  include ActionView::Helpers::DateHelper
  belongs_to :user
  has_many :replies
  has_many :likes, dependent: :destroy


  before_save :default_values
  before_destroy :destroy_replies

  validates :title, :description, presence: true

  def time_posted
    created_at.strftime('Posted at %H:%M %F')
  end

  def time_since_posted
    time_ago_in_words(self[:created_at]) + ' ago'
  end

  private

  def destroy_replies
    replies.destroy_all
  end

  def default_values
    self.likes ||= 0
    self.dislikes ||= 0
  end
end
