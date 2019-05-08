# frozen_string_literal: true

# Ratings controller
class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :blocked?

  def create
    star = params[:star]
    post = Post.find(params[:post_id])

    if already_rated?
      @rating = @ratings.first
      @rating.update(star: star)
    else
      @rating = Rating.create(user_id: current_user.id, post_id: post.id, star: star)
    end

    respond_to(&:js)

    update_post_rating(post)
  end

  private

  def update_post_rating(post)
    post.update(rating: post.ratings.inject(0.0) { |sum, rating| sum + rating.star } / post.ratings.size)
  end

  def already_rated?
    @ratings = Rating.where(user_id: current_user.id, post_id: params[:post_id])
    @ratings.exists?
  end
end
