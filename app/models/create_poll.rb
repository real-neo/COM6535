# == Schema Information
#
# Table name: create_polls
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CreatePoll < ApplicationRecord
  attr_accessor :post_type, :title, :description, :option1, :option2, :option3, :option4, :option5
end
