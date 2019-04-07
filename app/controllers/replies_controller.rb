class RepliesController < ApplicationController

  def create
    @post = Post.find(params.require(:reply).permit(:comment, :post_id)[:post_id])
    @reply = @post.replies.create! allowed_params

    respond_to do |f|
      f.html { redirect_to action: post_url, id: @post.id }
      # f.html { redirect_to post_url, @post.id }
      f.js
    end
  end

  private

  def allowed_params
    params.require(:reply).permit(:comment, :post_id).merge(user_id: current_user.id)
  end
end
