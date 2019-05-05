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

FactoryBot.define do
  factory :app_request do
    
  end
end
