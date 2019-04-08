class RepliesController < ApplicationController

  def create
    @post = Post.find(params.require(:reply).permit(:comment, :post_id, :original_id)[:post_id])
    @reply = @post.replies.create! allowed_params
    @post = @post.replies.order(:created_at)
    respond_to do |f|
      f.html { redirect_to post_url}
      f.js
    end
  end

  private

  def allowed_params
    params.require(:reply).permit(:comment, :post_id, :original_id).merge(user_id: current_user.id)
  end
end
