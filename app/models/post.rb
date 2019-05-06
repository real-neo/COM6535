# frozen_string_literal: true

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

# Post class
class Post < ApplicationRecord
  include ActionView::Helpers::DateHelper
  belongs_to :user
  has_many :replies
  has_many :reports
  has_many :ratings

  has_many :likes, dependent: :destroy

  has_one_attached :app_icon

  enum post_type: %i[Exercise Diet App]

  before_destroy :destroy_replies

  validates :title, :description, :post_type, presence: true

  validate :check_app_post_icon

  def time_posted
    created_at.strftime('Posted at %H:%M %F')
  end

  def time_since_posted
    time_ago_in_words(self[:created_at]) + ' ago'
  end

  private

  def destroy_replies
    replies.destroy_all
    reports.destroy_all
    ratings.destroy_all
  end

  def check_app_post_icon
    errors.add(:post, 'have icon only for app type.') if (post_type == 'App') != (app_icon.attached?)
  end
end
