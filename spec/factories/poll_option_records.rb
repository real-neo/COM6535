# == Schema Information
#
# Table name: poll_option_records
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  poll_option_id :integer
#  post_id        :integer
#  user_id        :integer
#
# Indexes
#
#  index_poll_option_records_on_poll_option_id  (poll_option_id)
#  index_poll_option_records_on_post_id         (post_id)
#  index_poll_option_records_on_user_id         (user_id)
#

FactoryBot.define do
  factory :poll_option_record do
    
  end
end
