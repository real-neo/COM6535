# == Schema Information
#
# Table name: replies
#
#  id         :integer          not null, primary key
#  comment    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  user_id    :integer
#
# Indexes
#
#  index_replies_on_post_id  (post_id)
#  index_replies_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Reply, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
