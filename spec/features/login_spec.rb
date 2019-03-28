require 'rspec'
require 'rails_helper'

describe 'Log in' do
  context 'A registered member of the website' do
    it 'should log in to the main page and see a welcome message' do
      FactoryBot.create(:user, email: 'aioannou2@sheffield.ac.uk', password: 'qweqweqwe')

      visit '/users/sign_in'
      fill_in('Email', with: 'aioannou2@sheffield.ac.uk')
      fill_in('Password', with: 'qweqweqwe')
      click_button "Log in"
      expect(page).to have_content "Signed in successfully."
    end

    it 'should not log in if they put wrong password see a meesage Invalid Email or password.' do
      FactoryBot.create(:user, email: 'aioannou2@sheffield.ac.uk', password: 'qweqweqwe')

      visit '/users/sign_in'
      fill_in('Email', with: 'aioannou2@sheffield.ac.uk')
      fill_in('Password', with: 'wrongpass')
      click_button "Log in"
      expect(page).to have_content "Invalid Email or password."
    end

    it 'should not log in if they put wrong email see a meesage Invalid Email or password.' do
      FactoryBot.create(:user, email: 'aioannou2@sheffield.ac.uk', password: 'qweqweqwe')

      visit '/users/sign_in'
      fill_in('Email', with: 'wrongemail34@sheffield.ac.uk')
      fill_in('Password', with: 'qweqweqwe')
      click_button "Log in"
      expect(page).to have_content "Invalid Email or password."
    end
  end

  context 'A not registered member of the website and see a message Invalid Email or password.' do
    it 'should not be able to log in' do
      visit '/users/sign_in'
      fill_in('Email', with: 'aioannou2@sheffield.ac.uk')
      fill_in('Password', with: 'qweqweqwe')
      click_button "Log in"
      expect(page).to have_content "Invalid Email or password."
    end
  end
end