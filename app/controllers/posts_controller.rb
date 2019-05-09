# frozen_string_literal: true

# Post controller class
class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new show_post_modal create destroy]
  before_action :blocked?, only: %i[new show_post_modal create destroy]

  require 'will_paginate/array'

  def home
    @most_voted_posts = Post.includes(user: { avatar_attachment: :blob }).order(likes_count: :desc).limit(10)
    @most_voted_posts = PostDecorator.decorate_collection(@most_voted_posts)

    top_voted_posts
  end

  def top_voted_posts
    @top_exercise = Post.where(post_type: 'Exercise').group(:id).order(likes_count: :desc).limit(5)
    @top_exercise = PostDecorator.decorate_collection(@top_exercise)

    @top_diet = Post.where(post_type: 'Diet').order(likes_count: :desc).limit(5)
    @top_diet = PostDecorator.decorate_collection(@top_diet)

    @top_apps = Post.where(post_type: 'App').order(rating: :desc).limit(5)
    @top_apps = PostDecorator.decorate_collection(@top_apps)
  end

  def index
    # check the forum that the user picked and assign
    session[:forum_type] = params[:forum_type] || 'Exercise'

    posts = (session[:forum_type] == 'App' ? Post.includes(app_icon_attachment: :blob) : Post.includes(:poll_options, user: { avatar_attachment: :blob })).where(post_type: session[:forum_type])
    @posts, @sort, @order = sorting_posts(posts)
    @posts = PostDecorator.decorate_collection(@posts.paginate(page: params[:page]))

    top_voted_posts
  end

  def show
    @post = Post.find(params[:id]).decorate
    @replies, @sort, @order = sorting_replies(Post.find(params[:id]).replies.includes(:user, :original))
    @replies = ReplyDecorator.decorate_collection(@replies.paginate(page: params[:page]))
  end

  def show_post_modal
    @modal = params[:type] || ''
    respond_to(&:js)
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
      @posts = Post.includes(user: { avatar_attachment: :blob }).where("(title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%') AND post_type != ?", keyword, keyword, 'App')
      @posts, @sort, @order = sorting_posts(@posts)
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
        @posts = Post.includes(user: :avatar_attachment).where("created_at > ? AND created_at < ? AND (title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%') AND post_type != ?", from, to, keyword, keyword, 'App')
        @exercise_is_checked = @diet_is_checked = true
      elsif params[:exercise] == '✅'
        @posts = Post.includes(:user).where("created_at > ? AND created_at < ? AND (title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%') AND post_type = ?", from, to, keyword, keyword, 'Exercise')
        @exercise_is_checked = true
      else
        @posts = Post.includes(:user).where("created_at > ? AND created_at < ? AND (title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%') AND post_type = ?", from, to, keyword, keyword, 'Diet')
        @diet_is_checked = true
      end
      @posts, @sort, @order = sorting_posts(@posts)
    else
      @posts = []
    end
    @posts = PostDecorator.decorate_collection(@posts.paginate(page: params[:page]))
    render 'posts/search'
  end

  private

  def sorting_posts(posts)
    order = (params[:order] == 'down' ? 'asc' : 'desc') # current down arrow means user wants up arrow which is asc order
    sort = case params[:sort]
           when 'Comments'
             posts = posts.order("replies_count #{order}")
             'Comments'
           when 'Likes'
             posts = posts.order("likes_count #{order}")
             'Likes'
           when 'Ratings'
             posts = posts.order("rating #{order}")
             'Ratings'
           else
             posts = posts.order("created_at #{order}")
             'Time'
           end
    order = (order == 'asc' ? 'up' : 'down') # do a exchange here
    [posts, sort, order]
  end

  def sorting_replies(replies)
    order = (params[:order] == 'down' ? 'asc' : 'desc')
    sort = case params[:sort]
           when 'Likes'
             replies = replies.order("likes_count #{order}")
             'Likes'
           else
             replies = replies.order("created_at #{order}")
             'Time'
           end
    order = (order == 'asc' ? 'up' : 'down')
    [replies, sort, order]
  end

  def allowed_params
    params.require(:post).permit(:post_type, :title, :description, :app_icon).merge(user_id: current_user.id)
  end
end
