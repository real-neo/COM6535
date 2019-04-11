# frozen_string_literal: true

# Post controller class
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

    @post = PostDecorator.find(params[:id]).decorate
    @replies = @post.replies
    @replies = @replies.sort { |b, a| a.created_at <=> b.created_at }
    @replies = ReplyDecorator.decorate(@replies)
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
    @post.destroy
    redirect_to posts_path
  end

  def search
    keyword = params[:keyword]
    if !keyword.nil? && (!keyword.eql? '')
      @posts = Post.where("title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%'", keyword, keyword)
    else
      @posts = nil
    end
  end

  private

  def allowed_params
    params.require(:post).permit(:title, :description).merge(:user_id => current_user.id)
  end
end
