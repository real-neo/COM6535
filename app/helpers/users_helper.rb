# frozen_string_literal: true

# Helper functions for user
module UsersHelper
  def user_image(user)
    if user.avatar.attached?
      user.avatar
    else
      '/images/default-avatar.png'
    end
  end
end
