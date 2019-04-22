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

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def display_delete_link
    if h.user_signed_in? && (model.user_id == h.current_user.id || h.current_user.admin?)
      h.link_to 'Delete', model, method: :delete, data: { confirm: 'Are you sure?' }, class: 'fa fa-trash'
    end
  end

  def display_reply_button
    if h.user_signed_in? && !h.current_user.blocked?
      h.link_to 'Reply', h.show_reply_modal_reply_path(model.id, is_post: 0), method: :post, remote: true, class: 'fa fa-comment'
    elsif h.user_signed_in? && h.current_user.blocked?
      h.link_to 'Reply', 'javascript: showBlockedMessage()', class: 'fa fa-comment'
    else
      h.link_to 'Reply', 'javascript: showLoginMessage()', class: 'fa fa-comment'
    end
  end
end
