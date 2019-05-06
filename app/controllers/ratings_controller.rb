# frozen_string_literal: true

# Ratings controller
class RatingsController < ApplicationController
  def create
    unless user_signed_in?
      respond_to do |f|
        f.js { render js: 'showLoginMessage()' }
      end
      return
    end

    star = params[:star]
    post = Post.find(params[:post_id])

    if already_rated?
      @rating = @ratings.first
      @rating.update(star: star)
    else
      @rating = Rating.create(user_id: current_user.id, post_id: post.id, star: star)
    end

    respond_to(&:js)
  end

  private

  def already_rated?
    @ratings = Rating.where(user_id: current_user.id, post_id: params[:post_id])
    @ratings.exists?
  end
end
