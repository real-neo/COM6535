class PostsController < ApplicationController

  def index
    @post = Post.new
    @posts = Post.all.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def show
    @reply = Reply.new
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.create!(allowed_params)
    respond_to do |f|
      f.html { redirect_to posts_url }
      f.js
    end
  end

  private

  def allowed_params
    params.require(:post).permit(:title,:description).merge(:user_id => current_user.id)
  end

end
