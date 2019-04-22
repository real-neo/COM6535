# frozen_string_literal: true

# Pages controller class
class PagesController < ApplicationController
  # before_action :authenticate_user!

  def home
    # @most_voted_posts = Post.select("posts.*, COUNT(likes.id) as likes_count").joins("LEFT OUTER JOIN likes ON (likes.post_id = posts.id)").group("posts.id").order('likes_count DESC').limit(3)
    @most_voted_posts = Post.includes(:user).left_outer_joins(:likes).select('posts.*, COUNT(likes.id) as likes_count').where(likes: { like: true }).group('posts.id').order('likes_count DESC').limit(3)
    @most_voted_posts = PostDecorator.decorate_collection(@most_voted_posts)
    # @most_voted_posts = @most_voted_posts.sort do |a, b|
    #   b.likes.count_likes <=> a.likes.count_likes
    # end.take(3)
  end
end
