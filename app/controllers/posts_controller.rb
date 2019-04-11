# frozen_string_literal: true

# Post controller class
class PostsController < ApplicationController
  def index
    @post = Post.new
    #check the forum that the user picked and assign
    session[:forum_type] = params[:forum_type] unless params[:forum_type].nil?
    session[:forum_type] = 'Exercise' if session[:forum_type].nil?
    if session[:forum_type] == 'Exercise'
      @posts = Post.where(post_type: 'Exercise').order(created_at: :desc)
    elsif session[:forum_type] == 'Diet'
      @posts = Post.where(post_type: 'Diet').order(created_at: :desc)
    end
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
    params.require(:post).permit(:post_type ,:title, :description).merge(user_id: current_user.id)
  end
end
