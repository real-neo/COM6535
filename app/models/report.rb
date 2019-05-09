# frozen_string_literal: true

# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  open       :boolean          default(TRUE)
#  reason     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  user_id    :integer
#
# Indexes
#
#  index_reports_on_post_id  (post_id)
#  index_reports_on_user_id  (user_id)
#

# Report class
class Report < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :user
  belongs_to :post

  scope :open, -> { where(open: true) }
  scope :close, -> { where(open: false) }

  def time_since_posted
    time_ago_in_words(self[:created_at]) + ' ago'
  end
end
