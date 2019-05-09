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

FactoryBot.define do
  factory :report do
    reason { "Reporting reason" }
    user { nil }
    post { nil }
  end
end
