# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
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

class Report < ApplicationRecord
  belongs_to :user
  belongs_to :post
end
