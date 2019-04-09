# == Schema Information
#
# Table name: posts
#
#  id          :integer          not null, primary key
#  description :string
#  dislikes    :integer
#  likes       :integer
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#

class Post < ApplicationRecord
  belongs_to :user
  has_many :replies

  before_destroy :destroy_replies

  validates :title, :description, presence: true

  def time_posted
    created_at.strftime("Posted at %H:%M %F")
  end

  private

  def destroy_replies
    replies.destroy_all
  end

end
