# frozen_string_literal: true

# Reports controller
class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin?, except: %i[create show_report_modal]
  before_action :blocked?

  def index
    @reports = Report.includes(user: :avatar_attachment, post: { user: :avatar_attachment }).all
    @reports = @reports.paginate(page: params[:report_page])
    @blocked_users = User.blocked
    @blocked_users = @blocked_users.paginate(page: params[:user_page])
  end

  def create
    @post = Post.find(params.require(:report).permit(:reason, :post_id)[:post_id])
    @post.reports.create! allowed_params
    respond_to(&:js)
  end

  def show_report_modal
    @post_id = params[:id]
    respond_to(&:js)
  end

  private

  def allowed_params
    params.require(:report).permit(:reason, :post_id).merge(user_id: current_user.id)
  end
end
