# frozen_string_literal: true

# Decorator for post class
class PostDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def display_delete_link
    if h.user_signed_in? && model.user_id == h.current_user.id
      h.link_to 'Delete', model, method: :delete, data: { confirm: 'Are you sure?' }, class: 'fa fa-trash'
    end
  end

  def display_reply_button
    h.link_to 'Reply', h.show_reply_modal_reply_path(model.id, is_post: 1), method: :post, remote: true, class: 'btn btn-danger btn-lg btn-block'
  end
end

#
# -if user_signed_in?
#    = link_to 'Reply', show_reply_modal_reply_path(@post.id, is_post: 1), remote: true, class: 'btn btn-danger btn-lg btn-block fill_container'
#    -else
#       %a#show-login-message.btn.btn-danger.btn-lg.btn-block.fill_container{href: "#"}
#       Reply
