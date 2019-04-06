# frozen_string_literal: true

# Control web behavior about users
class UsersController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      bypass_sign_in(@user)
      redirect_to edit_user_path(@user), notice: 'Update successfully!'
    else
      redirect_to edit_user_path(@user), alert: 'Operation failed!'
    end
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
