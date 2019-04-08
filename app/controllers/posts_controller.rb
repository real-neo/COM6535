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
    @replies = @post.replies
    @replies = @replies.sort { |b,a| a.created_at <=> b.created_at }

  end

  def create
    @post = Post.create!(allowed_params)
    respond_to do |f|
      f.html { redirect_to posts_url }
      f.js
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.update(title: "Title Removed", description: "Content removed")
    @post.save
    respond_to do |f|
      f.html { redirect_to post_url(@post) }
      f.js
    end
  end

  private

  def allowed_params
    params.require(:post).permit(:title,:description).merge(:user_id => current_user.id)
  end

end
