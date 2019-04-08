# frozen_string_literal: true

class RepliesController < ApplicationController
  def create
    @post = Post.find(params.require(:reply).permit(:comment, :post_id, :original_id)[:post_id])
    @reply = @post.replies.create! allowed_params
    @replies = @post.replies.order(:created_at)
    respond_to do |f|
      f.html { redirect_to post_url }
      f.js
    end
  end

  def show_reply_modal
    if params[:is_post] == '1'
      @is_post = 1
      @post_id = params[:id]
    else
      @is_post = 0
      # original reply
      @reply = Reply.find(params[:id])
    end
    respond_to do |f|
      f.html { redirect_to post_url }
      f.js
    end
  end

  private

  def allowed_params
    params.require(:reply).permit(:comment, :original_id, :post_id).merge(user_id: current_user.id)
  end
end
