# frozen_string_literal: true

require 'rspec'
require 'rails_helper'

describe 'use search function in site', js: true do
  context 'when a user has logged in' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:post1) { FactoryBot.create(:post, user: user, title: 'Test title 1', description: 'Test post content here.') }
    let!(:post2) { FactoryBot.create(:post, user: user, title: 'Test title 2', description: 'Chinese food is good.') }

    before do
      visit root_path
    end

    pending 'user can search by keyword' do
      expect(page).to_not have_content "Test title 2"
      fill_in 'keyword', with: 'food'
      click_button '🔍'
      expect(page).to have_content 'Test title 2'
    end
  end
end
