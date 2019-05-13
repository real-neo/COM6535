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

require 'rails_helper'

RSpec.describe PollOption, type: :model do
end
