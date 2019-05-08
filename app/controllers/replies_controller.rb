# frozen_string_literal: true

# Reply controller class
class RepliesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params.require(:reply).permit(:comment, :post_id, :original_id)[:post_id])
    @reply = (@post.replies.create! allowed_params).decorate
    @replies = ReplyDecorator.decorate_collection(@post.replies.order(:created_at))
    respond_to(&:js)
  end

  def show_reply_modal
    if params[:is_post] == '1'
      @is_post = 1
      @post_id = params[:id]
    else
      @is_post = 0
      @reply = Reply.find(params[:id])
    end
    respond_to(&:js)
  end

  def destroy
    @reply = Reply.find(params[:id])
    @post = @reply.post
    @reply.destroy
    redirect_to post_path(@post), notice: 'Reply deleted successfully.'
  end

  private

  def allowed_params
    params.require(:reply).permit(:comment, :original_id, :post_id).merge(user_id: current_user.id)
  end

end
