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
      redirect_to edit_user_path(current_user), notice: 'Update successfully!'
    else
      redirect_to edit_user_path(current_user), alert: 'Operation failed!'
    end
  end

  private

  def user_params
    params.require(:user).permit(:details, :email, :reset_password_token,
                                 :password, :password_confirmation)
  end
end
