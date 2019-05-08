# frozen_string_literal: true

# App Request controller
class AppRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin?, except: :create

  def index
    @app_requests = AppRequest.open.includes(:user).all.order(created_at: :desc)
    @app_requests = @app_requests.paginate(page: params[:open_page], per_page: 10)

    @closed_app_requests = AppRequest.close.includes(:user).all.order(created_at: :desc)
    @closed_app_requests = @closed_app_requests.paginate(page: params[:close_page], per_page: 10)
  end

  def create
    @app_request = AppRequest.new(allowed_params)

    if @app_request.save
      respond_to(&:js)
    else
      respond_to do |f|
        f.js { render 'posts/create_fail' }
      end
    end
  end

  def destroy
    app_request = AppRequest.find(params[:id])
    app_request.destroy
    redirect_to app_requests_path, notice: 'App request deleted successfully.'
  end

  def done
    app_request = AppRequest.find(params[:id])
    if app_request.update_attributes(open: false)
      redirect_to app_requests_path, notice: 'Marked successfully!'
    else
      redirect_to app_requests_path, notice: 'Operation failed!'
    end
  end

  def new_app_post
    @post_id = params[:id]
    respond_to(&:js)
  end

  private

  def allowed_params
    params.require(:app_request).permit(:url).merge(user_id: current_user.id)
  end
end
