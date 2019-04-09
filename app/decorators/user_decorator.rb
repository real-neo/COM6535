# frozen_string_literal: true

# helper methods
class UserDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def display_avatar(height, width)
    # height, width = image_size(size)
    h.image_tag user_image, height: height, width: width, class: 'img-circle'
  end

  private

  # def image_size(size)
  #   if size == 's'
  #     height,width = 30
  #   elsif size == 'md'
  #     height,width = 60
  #   else
  #     height,width = 100
  #   end
  #
  #   return height,width
  # end

  def user_image
    if model.avatar.attached?
      model.avatar
    else
      '/images/default-avatar.png'
    end
  end
end
