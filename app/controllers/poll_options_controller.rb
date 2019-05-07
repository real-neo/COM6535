# frozen_string_literal: true

# Poll Options controller
class PollOptionsController < ApplicationController
  def create
    unless user_signed_in?
      respond_to do |f|
        f.js { render js: 'showLoginMessage()' }
      end
      return
    end

    if params.has_key?('poll_option')
      PollOption.create(poll_option_params(params['poll_option']))
    else
      params['poll_options'].each do |poll_option|
        if poll_option['title'] != ''
          PollOption.create(poll_option_params(poll_option))
        end
      end
    end

    PollOption.create(title: title, post_id: params[:post_id])
  end
end
