class ReportsController < ApplicationController

  def index
    @reports = Report.includes(user: :avatar_attachment, post: { user: :avatar_attachment }).all
    @reported_users = User.blocked
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
