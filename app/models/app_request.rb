# frozen_string_literal: true

# == Schema Information
#
# Table name: app_requests
#
#  id         :integer          not null, primary key
#  open       :boolean          default(TRUE)
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_app_requests_on_user_id  (user_id)
#

# App Request class
class AppRequest < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :user

  scope :open, -> { where(open: true) }
  scope :close, -> { where(open: false) }

  def time_since_posted
    time_ago_in_words(self[:created_at]) + ' ago'
  end
end
