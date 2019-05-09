# frozen_string_literal: true

# Reports controller
class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin?, except: %i[create show_report_modal]
  before_action :blocked?

  def index
    @reports = Report.open.includes(user: :avatar_attachment, post: { user: :avatar_attachment }).all.order(created_at: :desc)
    @reports = @reports.paginate(page: params[:report_page])

    @closed_reports = Report.close.includes(user: :avatar_attachment, post: { user: :avatar_attachment }).all.order(created_at: :desc)
    @closed_reports = @closed_reports.paginate(page: params[:close_page], per_page: 10)

    @blocked_users = User.blocked.order(created_at: :desc)
    @blocked_users = @blocked_users.paginate(page: params[:user_page])
  end

  def create
    @post = Post.find(params.require(:report).permit(:reason, :post_id)[:post_id])
    @post.reports.create! allowed_params
    respond_to(&:js)
  end

  def done
    report = Report.find(params[:id])
    if report.update_attributes(open: false)
      redirect_to reports_path, notice: 'Marked successfully!'
    else
      redirect_to reports_path, notice: 'Operation failed!'
    end
  end

  def destroy
    report = Report.find(params[:id])
    report.destroy
    redirect_to reports_path, notice: 'Report deleted successfully.'
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
