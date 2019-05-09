# frozen_string_literal: true

# Likes controller class
class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :blocked?

  def create
    @liked = params[:liked] == 'true'
    @type = params[:type] == 'post' ? 'Post' : 'Reply'

    model = @type == 'post' ? Post.find(params[:post_id]) : Reply.find(params[:reply_id])
    @id = model.id

    if already_liked?
      @like = @likes.first
      if @like.like == @liked
        @like.destroy
        @liked = nil
      else
        @like.update(like: @liked)
      end
    else
      @like = Like.create(user_id: current_user.id, likeable_id: model.id, likeable_type: @type, like: @liked)
    end

    update_post_like_dislike(post)

    @like_text = model.decorate.display_like_count

    respond_to(&:js)
  end

  private

  def update_post_like_dislike(post)
    post.update(likes_count: post.likes.where(like: true).count)
    post.update(dislikes_count: post.likes.where(like: false).count)
  end

  def already_liked?
    @likes = Like.where(user_id: current_user.id, likeable_id: @id, likeable_type: @type)
    @likes.exists?
  end
end
