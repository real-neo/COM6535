# frozen_string_literal: true

# Poll Options controller
class PollOptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :blocked?
end
