# frozen_string_literal: true

require 'rspec'
require 'rails_helper'

describe 'use sidebar menu' do
  context 'when a user has not log in' do
    before do
      visit root_path
    end

    it 'user can click login link' do
      page.find(:css, 'i[class="fa fa-bars fa-2x pull-right navbar-btn"]').click
      expect(page).to have_content 'Login'
      click_link 'Login'
      expect(current_path).to eql(new_user_session_path)
    end

    it 'user can click register link' do
      page.find(:css, 'i[class="fa fa-bars fa-2x pull-right navbar-btn"]').click
      expect(page).to have_content 'Register'
      click_link 'Register'
      expect(current_path).to eql(new_user_registration_path)
    end
  end

  context 'when a user has logged in' do
    let(:user) { FactoryBot.create(:user) }

    before do
      login_as user
      visit root_path
    end

    it 'user can click settings link' do
      page.find(:css, 'i[class="fa fa-bars fa-2x pull-right navbar-btn"]').click
      expect(page).to have_content 'Settings'
      click_link 'Settings'
      expect(current_path).to eql(edit_user_path(1))
    end

    it 'user can click logout link' do
      page.find(:css, 'i[class="fa fa-bars fa-2x pull-right navbar-btn"]').click
      expect(page).to have_content 'Logout'
      click_link 'Logout'
      expect(current_path).to eql(root_path)
      expect(page).to have_content 'Login'
    end
  end
end

