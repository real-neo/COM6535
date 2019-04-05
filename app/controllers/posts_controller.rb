class PostsController < ApplicationController

  def index
    @post = Post.new
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create

    @post = Post.new(allowed_params)
    @post.user = current_user
    @post.save

    respond_to do |f|
      f.html { redirect_to posts_url }
      f.js
    end
  end

  def allowed_params
    params.require(:post).permit(:title,:description)
  end

end
