# frozen_string_literal: true

# Post controller class
class PostsController < ApplicationController
  def index
    @post = Post.new.decorate
    # check the forum that the user picked and assign
    session[:forum_type] = params[:forum_type] unless params[:forum_type].nil?
    session[:forum_type] = 'Exercise' if session[:forum_type].nil?
    if session[:forum_type] == 'Exercise'
      @posts = PostDecorator.decorate_collection(Post.includes(:user).where(post_type: 'Exercise').paginate(page: params[:page]).order(created_at: :desc))
    elsif session[:forum_type] == 'Diet'
      @posts = PostDecorator.decorate_collection(Post.includes(:user).where(post_type: 'Diet').paginate(page: params[:page]).order(created_at: :desc))
    end
  end

  def new
    @post = Post.new.decorate
  end

  def show
    @post = Post.find(params[:id]).decorate
    @replies = @post.replies.includes(:user, :original)
    @replies = @replies.sort { |b, a| a.created_at <=> b.created_at }
    @replies = ReplyDecorator.decorate_collection(@replies.paginate(page: params[:page]))
  end

  def create
    @post = Post.create!(allowed_params).decorate
    respond_to(&:js)
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
      got_posts = Post.includes(:user).where("title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%'", keyword, keyword)
      @posts = PostDecorator.decorate_collection(got_posts.paginate(page: params[:page]))
    else
      @posts = nil
    end
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
        got_posts = Post.includes(:user).where("created_at > ? AND created_at < ? AND (title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%')", from, to, keyword, keyword)
        @exercise_is_checked = @diet_is_checked = true
      elsif params[:exercise] == '✅'
        got_posts = Post.includes(:user).where("created_at > ? AND created_at < ? AND (title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%') AND post_type = ?", from, to, keyword, keyword, '0')
        @exercise_is_checked = true
      else
        got_posts = Post.includes(:user).where("created_at > ? AND created_at < ? AND (title LIKE '%' || ? || '%' OR description LIKE '%' || ? || '%') AND post_type = ?", from, to, keyword, keyword, '1')
        @diet_is_checked = true
      end
      @posts = PostDecorator.decorate_collection(got_posts.paginate(page: params[:page]))
    else
      @posts = nil
    end

    render 'posts/search'
  end

  private

  def allowed_params
    params.require(:post).permit(:post_type, :title, :description).merge(user_id: current_user.id)
  end
end
