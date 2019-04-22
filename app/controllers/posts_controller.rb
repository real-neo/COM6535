# frozen_string_literal: true

# Post controller class
class PostsController < ApplicationController
  def index
    @post = Post.new
    #check the forum that the user picked and assign
    session[:forum_type] = params[:forum_type] unless params[:forum_type].nil?
    session[:forum_type] = 'Exercise' if session[:forum_type].nil?
    if session[:forum_type] == 'Exercise'
      @posts = Post.includes(:user).where(post_type: 'Exercise').order(created_at: :desc)
    elsif session[:forum_type] == 'Diet'
      @posts = Post.includes(:user).where(post_type: 'Diet').order(created_at: :desc)
    end
  end

  def new
    @post = Post.new
  end

  def show
    @reply = Reply.new

    @post = PostDecorator.find(params[:id]).decorate
    @replies = @post.replies.includes(:user, :original)
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
    redirect_to posts_path, notice: 'Thread content deleted successfully.'
  end

  def search
    keyword = params[:keyword]
    if !keyword.nil? && (!keyword.eql? '')
      @posts = Post.where("title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%'", keyword, keyword)
    else
      @posts = nil
    end
    @exercise_is_checked = @diet_is_checked = true
    @from_date = Date.current.last_month
    @to_date = Date.current
  end

  def advanced_search
    search

    from = DateTime.new(2000, 1, 1)
    to = DateTime.current
    begin
      unless params[:from].nil?
        from = DateTime.parse(params[:from])
      end
      unless params[:to].nil?
        to = DateTime.parse(params[:to]).end_of_day
      end
    rescue ArgumentError => e
      redirect_to search_posts_path, alert: e.message
      return
    end
    @from_date = from.to_date
    @to_date = to.to_date

    @posts = @posts.where('created_at > ? AND created_at < ?', from, to)

    post_e = post_d = []
    @exercise_is_checked = @diet_is_checked = false
    if params[:exercise] == '✅'
      post_e = @posts.where(post_type: 'Exercise')
      @exercise_is_checked = true
    end
    if params[:diet] == '✅'
      post_d = @posts.where(post_type: 'Diet')
      @diet_is_checked = true
    end
    @posts = post_e + post_d

    render 'posts/search'
  end

  private

  def allowed_params
    params.require(:post).permit(:post_type, :title, :description).merge(user_id: current_user.id)
  end
end
