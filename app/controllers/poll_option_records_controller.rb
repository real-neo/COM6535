# frozen_string_literal: true

# Poll Option Records controller
class PollOptionRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :blocked?

  def create
    post = Post.find(params[:post_id])
    option = PollOption.find(params[:poll_option_id])

    if already_voted?
      @poll_option_record = @poll_option_records.first
      if @poll_option_record.poll_option == option
        @poll_option_record.destroy
        @poll_option_record = nil
      else
        @poll_option_record.destroy
        @poll_option_record = PollOptionRecord.create(allowed_params)
      end
    else
      @poll_option_record = PollOptionRecord.create(user_id: current_user.id, post_id: post.id, poll_option_id: option.id)
    end

    @post_id = post.id
    @poll_buttons = post.decorate.display_poll

    respond_to(&:js)
  end

  private

  # def allowed_params
  #   params.require(:poll).permit(:post_type, :title).merge(user_id: current_user.id)
  # end
  def allowed_params
    params.require(:poll_option_record).permit(:user_id , :post_id ,:poll_option_id).merge(user_id: current_user.id)
  end

  def update_post_rating(post)
    post.update(rating: post.ratings.inject(0.0) { |sum, rating| sum + rating.star } / post.ratings.size)
  end

  def already_voted?
    @poll_option_records = PollOptionRecord.where(user_id: current_user.id, post_id: params[:post_id])
    @poll_option_records.exists?
  end
end
