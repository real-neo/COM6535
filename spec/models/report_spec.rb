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

require 'rails_helper'

RSpec.describe Report, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
