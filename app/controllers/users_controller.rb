# frozen_string_literal: true

# Control web behavior about users
class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id]).decorate
  end

  def edit
    @user = current_user.decorate
  end

  def update
    @user = current_user.decorate
    if @user.update_attributes(user_params)
      bypass_sign_in(@user)
      redirect_to edit_user_path(@user), notice: 'Update successfully!'
    else
      redirect_to edit_user_path(@user), alert: 'Operation failed!'
    end
  end

  def home
    @user = current_user.decorate

    @posts = Post.includes(:user, :poll_options).where.not(post_type: 'App').where(user_id: @user.id).order(created_at: :desc)
    @posts = PostDecorator.decorate_collection(@posts.paginate(page: params[:post_page], per_page: 10))

    @replies_to_me = Reply.includes(:user, :original, :post).where(posts: { user_id: @user.id }).where.not(posts: { post_type: 'App' } )
                          .or(Reply.includes(:user, :original, :post).where(originals_replies: { user_id: @user.id })).order(created_at: :desc)
    @replies_to_me = ReplyDecorator.decorate_collection(@replies_to_me.paginate(page: params[:reply_to_me_page], per_page: 10))

    @replies = Reply.includes(:user, :original).where(user_id: @user.id).order(created_at: :desc)
    @replies = ReplyDecorator.decorate_collection(@replies.paginate(page: params[:reply_page], per_page: 10))
  end

  def ban_user
    @user = User.find(params[:id])
    if @user.update_attributes(blocked: true)
      UserMailer.block_user_mailer(@user).deliver
      redirect_to reports_path, notice: 'Blocked user'
    else
      redirect_to reports_path, notice: 'Operation failed!'
    end
  end

  def unblock_user
    @user = User.find(params[:id])
    if @user.update_attributes(blocked: false)
      # UserMailer.block_user_mailer(@user).deliver
      redirect_to reports_path, notice: 'Unblocked user'
    else
      redirect_to reports_path, notice: 'Operation failed!'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    session.clear
    redirect_to posts_path, notice: 'Account deleted successfully.'
  end

  private

  def user_params
    params.require(:user).permit(:details, :email, :avatar, :password,
                                 :reset_password_token, :password_confirmation)
  end

  rescue_from ActionController::ParameterMissing do |_e|
    redirect_to edit_user_path(@user), alert: 'Operation failed!'
  end
end
