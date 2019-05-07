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

FactoryBot.define do
  factory :poll_option do
    
  end
end
