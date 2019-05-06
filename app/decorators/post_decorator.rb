# frozen_string_literal: false

# Decorator for post class
class PostDecorator < Draper::Decorator
  include PostsHelper
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

  def app_icon_link
    if model.app_icon.attached?
      model.app_icon
    else
      '/images/default-app-icon.png'
    end
  end

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
      h.link_to 'Reply', h.show_reply_modal_reply_path(model.id, is_post: 1), method: :post, remote: true, class: "btn #{btn_class(model.post_type)} btn-lg btn-block fa fa-comment"
    elsif h.user_signed_in? && h.current_user.blocked?
      h.link_to 'Reply', 'javascript: showBlockedMessage()', class: "btn #{btn_class(model.post_type)} btn-lg btn-block fa fa-comment"
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

  def calc_ratings
    ratings = model.ratings
    if ratings.exists?
      'Ratings: ' + (ratings.inject(0.0) { |sum, rating| sum + rating.star } / ratings.size).to_s
    end
  end

  def display_rating
    content = ''
    star_no = 0
    if h.user_signed_in?
      ratings = Rating.where(user_id: h.current_user.id, post_id: model.id)
      if ratings.exists?
        rating = ratings.first
        rating.star.times do
          star_no += 1
          content.concat h.link_to(h.fa_icon('star 2x', class: 'rating-star checked-star'), h.post_ratings_path(model, star: star_no), method: :post, remote: true, style: 'color: inherit;', id: "star-#{star_no}", onmouseover: "changeStarColor(#{star_no})", onmouseout: 'resetStarColor()')
        end
        (5 - rating.star).times do
          star_no += 1
          content.concat h.link_to(h.fa_icon('star 2x', class: 'rating-star'), h.post_ratings_path(model, star: star_no), method: :post, remote: true, style: 'color: inherit;', id: "star-#{star_no}", onmouseover: "changeStarColor(#{star_no})", onmouseout: 'resetStarColor()')
        end
        content
      else
        5.times do
          star_no += 1
          content.concat h.link_to(h.fa_icon('star 2x', class: 'rating-star'), h.post_ratings_path(model, star: star_no), method: :post, remote: true, style: 'color: inherit;', id: "star-#{star_no}", onmouseover: "changeStarColor(#{star_no})", onmouseout: 'resetStarColor()')
        end
        content
      end
    else
      5.times do
        star_no += 1
        content.concat h.link_to(h.fa_icon('star 2x', class: 'rating-star'), 'javascript: showLoginMessage()', style: 'color: inherit;', id: "star-#{star_no}", onmouseover: "changeStarColor(#{star_no})", onmouseout: 'resetStarColor()')
      end
      content
    end
  end
end
