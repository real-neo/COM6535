class PagesController < ApplicationController

  # before_action :authenticate_user!

  def home
    @current_nav_identifier = :home
  end


end
