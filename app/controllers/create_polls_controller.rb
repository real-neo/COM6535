# frozen_string_literal: true

# Poll Options controller
class CreatePollsController < ApplicationController
  def create
    @create_poll = CreatePoll.new

    @post = Post.create(post_type: params[:create_poll][:post_type], title: params[:create_poll][:title], description: params[:create_poll][:description], user_id: current_user.id).decorate

    if @post.valid?
      @post.poll_options.create(title: params[:create_poll][:option1]) if params[:create_poll][:option1] != ''
      @post.poll_options.create(title: params[:create_poll][:option2]) if params[:create_poll][:option2] != ''
      @post.poll_options.create(title: params[:create_poll][:option3]) if params[:create_poll][:option3] != ''
      @post.poll_options.create(title: params[:create_poll][:option4]) if params[:create_poll][:option4] != ''
      @post.poll_options.create(title: params[:create_poll][:option5]) if params[:create_poll][:option5] != ''

      if @post.poll_options.count < 2
        @post.destroy
        respond_to do |f|
          f.js { render 'create_poll_fail.js.erb' }
        end
      end
    else
      respond_to do |f|
        f.js { render 'create_fail.js.erb' }
      end
    end

    respond_to(&:js)

    @create_poll.destroy
  end
end
