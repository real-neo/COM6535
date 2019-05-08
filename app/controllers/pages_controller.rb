# frozen_string_literal: true

# Pages controller class
class PagesController < ApplicationController
  def home
    @most_voted_posts = Post.includes(:user).left_outer_joins(:likes).select('posts.*, COUNT(likes.id) as likes_count').where(likes: { like: true }).group('posts.id').order('likes_count DESC').limit(5)
    @most_voted_posts = PostDecorator.decorate_collection(@most_voted_posts)
  end
end
