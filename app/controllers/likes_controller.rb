# frozen_string_literal: true

# Likes controller class
class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :blocked?

  def create
    @liked = params[:liked] == 'true'
    post = Post.find(params[:post_id])

    if already_liked?
      @like = @likes.first
      if @like.like == @liked
        @like.destroy
        @liked = nil
      else
        @like.update(like: @liked)
      end
    else
      @like = Like.create(user_id: current_user.id, post_id: post.id, like: @liked)
    end

    update_post_like_dislike(post)

    @post_id = post.id
    @like_text = post.decorate.display_like_count

    respond_to(&:js)
  end

  private

  def update_post_like_dislike(post)
    post.update(likes_count: post.likes.where(like: true).count)
    post.update(dislikes_count: post.likes.where(like: false).count)
  end

  def already_liked?
    @likes = Like.where(user_id: current_user.id, post_id: params[:post_id])
    @likes.exists?
  end
end
