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

  def display_like
    if h.user_signed_in?
      is_liked = Like.where(user_id: h.current_user.id, likeable_id: model.id, likeable_type: 'reply').exists? && Like.find_by(user_id: h.current_user.id, likeable_id: model.id, likeable_type: 'reply').like
      color = is_liked ? '#4169e1' : 'black'

      h.link_to h.fa_icon('thumbs-up 2x'), h.reply_likes_path(model, liked: true, type: 'reply'), method: :post, remote: true, id: 'like_icon', style: "color: #{color};"
    else
      h.link_to h.fa_icon('thumbs-up 2x'), 'javascript: showLoginMessage()', id: 'like_icon', style: 'color: black;'
    end
  end

  def display_dislike
    if h.user_signed_in?
      is_disliked = Like.where(user_id: h.current_user.id, likeable_id: model.id, likeable_type: 'reply').exists? && !Like.find_by(user_id: h.current_user.id, likeable_id: model.id, likeable_type: 'reply').like
      color = is_disliked ? '#ff0003' : 'black'

      h.link_to h.fa_icon('thumbs-down 2x', class: 'fa-flip-horizontal'), h.reply_likes_path(model, liked: false, type: 'reply'), method: :post, remote: true, id: 'dislike_icon', style: "color: #{color};"
    else
      h.link_to h.fa_icon('thumbs-down 2x', class: 'fa-flip-horizontal'), 'javascript: showLoginMessage()', id: 'dislike_icon', style: 'color: black;'
    end
  end

  def display_like_count
    like_amount = model.likes.where(like: true).count
    dislike_amount = model.likes.where(like: false).count
    like_amount.to_s + ' ' + (like_amount == 1 ? 'Like' : 'Likes') + ' ' + dislike_amount.to_s + ' ' + (dislike_amount == 1 ? 'Dislike' : 'Dislikes')
  end

  def display_delete_link
    if h.user_signed_in? && (model.user_id == h.current_user.id || h.current_user.admin?)
      h.link_to 'Delete', model, method: :delete, data: { confirm: 'Are you sure?' }, class: 'fa fa-trash'
    end
  end

  def display_reply_button
    h.link_to 'Reply', h.show_reply_modal_reply_path(model.id, is_post: 0), method: :post, remote: true, class: 'fa fa-comment'
  end
end
