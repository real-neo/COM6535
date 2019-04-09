# frozen_string_literal: true

class LikesController < ApplicationController

  def create
    @liked = params[:liked] == 'true'
    @post = Post.find(params[:post_id])
    @both_black = false

    if already_liked?
      @like = Like.where(user_id: current_user.id, post_id: params[:post_id]).first
      if @like.like == @liked
        @like.destroy
        @both_black = true
      else
        @like.update(like: @liked)
      end
    else
      Like.create!(user_id: current_user.id, post_id: @post.id, like: @liked)
    end

    @text = @post.decorate.display_like_count

    respond_to do |f|
      f.html { redirect_to posts_url }
      f.js
    end
  end

  private

  def already_liked?
    @like = Like.where(user_id: current_user.id, post_id:
        params[:post_id]).exists?
  end
end
