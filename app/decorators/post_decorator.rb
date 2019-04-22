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
    if h.user_signed_in? && (model.user_id == h.current_user.id || h.current_user.admin?)
      h.link_to 'Delete', model, method: :delete, data: { confirm: 'Are you sure?' }, class: 'fa fa-trash'
    end
  end

  def display_block_link
    if h.user_signed_in? && h.current_user.admin?
      h.link_to 'Block user', h.ban_user_user_path(model.user), method: :post, data: { confirm: 'Are you sure?' }, class: 'fa fa-ban'
    else
      h.link_to 'Block user', 'javascript: showLoginMessage()', class: 'fa fa-ban'
    end
  end

  def display_reply_button
    if h.user_signed_in? && !h.current_user.blocked?
      h.link_to 'Reply', h.show_reply_modal_reply_path(model.id, is_post: 1), method: :post, remote: true, class: 'btn btn-danger btn-lg btn-block'
    elsif h.user_signed_in? && h.current_user.blocked?
      h.link_to 'Reply', 'javascript: showBlockedMessage()', class: 'btn btn-danger btn-lg btn-block'
     else
      h.link_to 'Reply', 'javascript: showLoginMessage()'
    end
  end

  def display_report_button
    if h.user_signed_in?
      h.link_to 'Report', h.show_report_modal_report_path(model), class: 'fa fa-flag', method: :post, remote: true
    else
      h.link_to 'Report', 'javascript: showLoginMessage()', class: 'fa fa-flag'
    end
  end

  def display_like
    if h.user_signed_in?
      is_liked = Like.where(user_id: h.current_user.id, post_id: model.id).exists? && Like.find_by(user_id: h.current_user.id, post_id: model.id).like
      color = is_liked ? '#4169e1' : 'black'

      h.link_to h.fa_icon('thumbs-up 2x'), h.post_likes_path(model, liked: true), method: :post, remote: true, id: 'like_icon', style: "color: #{color};"
    else
      h.link_to h.fa_icon('thumbs-up 2x'), 'javascript: showLoginMessage()', id: 'like_icon', style: 'color: black;'
    end
  end

  def display_dislike
    if h.user_signed_in?
      is_disliked = Like.where(user_id: h.current_user.id, post_id: model.id).exists? && !Like.find_by(user_id: h.current_user.id, post_id: model.id).like
      color = is_disliked ? '#ff0003' : 'black'

      h.link_to h.fa_icon('thumbs-down 2x', class: 'fa-flip-horizontal'), h.post_likes_path(model, liked: false), method: :post, remote: true, id: 'dislike_icon', style: "color: #{color};"
    else
      h.link_to h.fa_icon('thumbs-down 2x', class: 'fa-flip-horizontal'), 'javascript: showLoginMessage()', id: 'dislike_icon', style: 'color: black;'
    end
  end

  def display_like_count
    like_amount = model.likes.where(like: true).count
    dislike_amount = model.likes.where(like: false).count
    like_amount.to_s + ' ' + (like_amount == 1 ? 'Like' : 'Likes') + ' ' + dislike_amount.to_s + ' ' + (dislike_amount == 1 ? 'Dislike' : 'Dislikes')
  end
end
#
# -if user_signed_in?
#    = link_to 'Reply', show_reply_modal_reply_path(@post.id, is_post: 1), remote: true, class: 'btn btn-danger btn-lg btn-block fill_container'
#    -else
#       %a#show-login-message.btn.btn-danger.btn-lg.btn-block.fill_container{href: "#"}
#       Reply
