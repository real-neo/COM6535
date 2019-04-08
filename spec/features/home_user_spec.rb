# frozen_string_literal: true

require 'rspec'
require 'rails_helper'

describe 'user home page', js: true do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post, user: user, title: 'Test post title', description: 'Just a test post.') }

  context 'when a user has not log in' do
    it 'should redirect to log in page' do
      visit home_user_path(user.id)
      expect(current_path).to eql(new_user_session_path)
    end
  end

  context 'when a user has logged in' do
    before do
      login_as user
      visit home_user_path(user.id)
    end

    pending 'user can see his posts' do
      expect(page).to have_content 'Your Posts'
      expect(page).to have_content 'Test post title'
      expect(page).to have_content 'Just a test post.'
    end
  end
end
