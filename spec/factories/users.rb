# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  city                   :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  firstname              :string
#  lastname               :string
#  location               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryBot.define do
  factory :user do
    firstname {'Alexis'}
    lastname {'Ioannou'}
    location {'UK'}
    city {'Sheffield'}
    email {'aioannou2@gmail.com'}
    username {'acp18ai'}
    password {'qweqweqwe'}
    # encrypted_password {'qweqweqwe'}
  end
end
