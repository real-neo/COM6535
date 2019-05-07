# frozen_string_literal: true

# == Schema Information
#
# Table name: poll_options
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#
# Indexes
#
#  index_poll_options_on_post_id  (post_id)
#

# Poll Option class
class PollOption < ApplicationRecord
  belongs_to :post

  has_many :poll_option_records, dependent: :destroy

  validates :title, presence: true
  validates :title, length: { minimum: 1, maximum: 50 }
end
