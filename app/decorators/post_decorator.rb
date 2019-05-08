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
    h.link_to 'Block user', h.ban_user_user_path(model.user), method: :post, data: { confirm: 'Are you sure?' }, class: 'fa fa-ban'
  end

  def display_reply_button
    h.link_to model.post_type == 'App' ? 'Review' : 'Reply', h.show_reply_modal_reply_path(model.id, is_post: 1), method: :post, remote: true, class: "btn #{btn_class(model.post_type)} btn-lg btn-block fa fa-comment"
  end

  def display_report_button
    h.link_to 'Report', h.show_report_modal_report_path(model), class: 'fa fa-flag', method: :post, remote: true
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

  def show_ratings
    'Ratings: ' + model.rating.to_s unless model.rating.nil?
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
      else
        5.times do
          star_no += 1
          content.concat h.link_to(h.fa_icon('star 2x', class: 'rating-star'), h.post_ratings_path(model, star: star_no), method: :post, remote: true, style: 'color: inherit;', id: "star-#{star_no}", onmouseover: "changeStarColor(#{star_no})", onmouseout: 'resetStarColor()')
        end
      end
    else
      5.times do
        star_no += 1
        content.concat h.link_to(h.fa_icon('star 2x', class: 'rating-star'), 'javascript: showLoginMessage()', style: 'color: inherit;', id: "star-#{star_no}", onmouseover: "changeStarColor(#{star_no})", onmouseout: 'resetStarColor()')
      end
    end
    content
  end

  def display_poll
    content = ''
    poll_btn_class = %w[success info warning danger primary]

    if model.poll_options.exists?
      count = -1
      model.poll_options.each do |option|
        content.concat h.link_to(option.title + " - #{option.poll_option_records.count}", h.post_poll_option_poll_option_records_path(model, option), method: :post, remote: true, class: "btn btn-#{poll_btn_class[count += 1]}", style: "width: #{ 1.0 / model.poll_options.count * 100 }%")
      end
    end
    content
  end
end
