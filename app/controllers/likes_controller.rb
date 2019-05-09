# frozen_string_literal: true

# Likes controller class
class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :blocked?

  def create
    @liked = params[:liked] == 'true'
    @type = params[:type] == 'post' ? 'Post' : 'Reply'

    model = @type == 'Post' ? Post.find(params[:post_id]) : Reply.find(params[:reply_id])
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

    update_like_dislike(model)

    @like_text = model.decorate.display_like_count

    respond_to(&:js)
  end

  private

  def update_like_dislike(model)
    model.update(likes_count: model.likes.where(like: true).count)
    model.update(dislikes_count: model.likes.where(like: false).count)
  end

  def already_liked?
    @likes = Like.where(user_id: current_user.id, likeable_id: @id, likeable_type: @type)
    @likes.exists?
  end
end
