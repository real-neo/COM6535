# == Schema Information
#
# Table name: ratings
#
#  id         :integer          not null, primary key
#  star       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  user_id    :integer
#
# Indexes
#
#  index_ratings_on_post_id  (post_id)
#  index_ratings_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Rating, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
