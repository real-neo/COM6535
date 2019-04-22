# frozen_string_literal: true

# Decorator for reply class
class ReplyDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def display_reply_button
    if h.user_signed_in? && !h.current_user.blocked?
      h.link_to 'Reply', h.show_reply_modal_reply_path(model.id, is_post: 0), method: :post, remote: true
    elsif h.user_signed_in? && h.current_user.blocked?
      h.link_to 'Reply', 'javascript: showBlockedMessage()'
    else
      h.link_to 'Reply', 'javascript: showLoginMessage()'
    end
  end

  def display_replies
    if model.blank?
      h.no_record_tr(5)
    else
      h.render model
    end
  end
end
