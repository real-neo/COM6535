# frozen_string_literal: true

# Post controller class
class PostsController < ApplicationController
  require 'will_paginate/array'

  def index
    @post = Post.new.decorate
    # check the forum that the user picked and assign
    session[:forum_type] = params[:forum_type] unless params[:forum_type].nil?
    session[:forum_type] = 'Exercise' if session[:forum_type].nil?

    posts = (session[:forum_type] == 'App' ? Post.includes(:ratings, :app_icon_attachment) : Post.includes(user: :avatar_attachment)).where(post_type: session[:forum_type])
    @posts, @sort = sorting_posts(posts)
    @posts = PostDecorator.decorate_collection(@posts.paginate(page: params[:page]))
  end

  def new
    @post = Post.new.decorate
  end

  def show
    @post = Post.find(params[:id]).decorate
    @replies, @sort = sorting_replies(Post.find(params[:id]).replies.includes(:user, :original))
    @replies = ReplyDecorator.decorate_collection(@replies.paginate(page: params[:page]))
  end

  def create
    @post = Post.create(allowed_params).decorate
    if @post.valid?
      if @post.post_type == 'App' && !current_user.admin?
        @post.destroy
        respond_to do |f|
          f.js { render 'create_fail.js.erb' }
        end
      elsif @post.post_type == 'App'
        redirect_to @post, notice: 'Your post has been submitted!'
      else
        respond_to(&:js)
      end
    else
      respond_to do |f|
        f.js { render 'create_fail.js.erb' }
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: 'Thread content deleted successfully.'
  end

  def search
    keyword = params[:keyword]
    @exercise_is_checked = @diet_is_checked = true
    @from_date = Date.current.last_month
    @to_date = Date.current
    if !keyword.nil? && (!keyword.eql? '')
      @posts = Post.includes(:user).where("title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%'", keyword, keyword)
      @posts, @sort = sorting_posts(@posts)
    else
      @posts = []
    end
    @posts = PostDecorator.decorate_collection(@posts.paginate(page: params[:page]))
  end

  def advanced_search
    keyword = params[:keyword]

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

    @exercise_is_checked = @diet_is_checked = false

    if !keyword.nil? && (!keyword.eql? '') && (params[:exercise] == '✅' || params[:diet] == '✅')
      if params[:exercise] == '✅' && params[:diet] == '✅'
        @posts = Post.includes(:user).where("created_at > ? AND created_at < ? AND (title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%')", from, to, keyword, keyword)
        @exercise_is_checked = @diet_is_checked = true
      elsif params[:exercise] == '✅'
        @posts = Post.includes(:user).where("created_at > ? AND created_at < ? AND (title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%') AND post_type = ?", from, to, keyword, keyword, '0')
        @exercise_is_checked = true
      else
        @posts = Post.includes(:user).where("created_at > ? AND created_at < ? AND (title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%') AND post_type = ?", from, to, keyword, keyword, '1')
        @diet_is_checked = true
      end
      @posts, @sort = sorting_posts(@posts)
    else
      @posts = []
    end
    @posts = PostDecorator.decorate_collection(@posts.paginate(page: params[:page]))
    render 'posts/search'
  end

  private

  def sorting_posts(posts)
    order = if params[:order] == '⬆️'
              'asc'
            else
              'desc'
            end
    sort = if params[:sort] == 'Comments'
             posts = posts.left_outer_joins(:replies).select('posts.*, COUNT(replies.id) as replies_count').group('posts.id').order("replies_count #{order}")
             'Comments'
           elsif params[:sort] == 'Likes'
             posts = posts.left_outer_joins(:likes).select('posts.*, COUNT(likes.id) as likes_count').where(likes: { like: true }).group('posts.id').order("likes_count #{order}")
             'Likes'
           else
             posts = posts.order("created_at #{order}")
             'Time'
           end

    sort += (order == 'asc' ? '⬆️' : '⬇️')
    [posts, sort]
  end

  def sorting_replies(replies)
    order = if params[:order] == '⬆️'
              'asc'
            else
              'desc'
            end
    replies = replies.order("created_at #{order}")
    sort = 'Time'

    sort += (order == 'asc' ? '⬆️' : '⬇️')
    [replies, sort]
  end

  def allowed_params
    params.require(:post).permit(:post_type, :title, :description, :app_icon).merge(user_id: current_user.id)
  end
end
