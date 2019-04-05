# frozen_string_literal: true

require 'rspec'
require 'rails_helper'

describe 'edit user information' do
  context 'when a user has not log in' do
    it 'should redirect to log in page' do
      visit edit_user_path(1)
      expect(current_path).to eql(new_user_session_path)
    end
  end

  context 'when a user has logged in' do
    let(:user) { FactoryBot.create(:user, password: 'f4k3p455w0rd') }

    before do
      login_as user
      visit edit_user_path(1)
    end

    it 'user can change his details' do
      click_link 'Change of personal details'
      fill_in 'Details', with: 'My new details'
      click_button 'Update'
      expect(page).to have_content 'Update successfully!'
    end

    it 'user can change his password' do
      click_link 'Change of password'
      fill_in 'New password', with: 'JustNewPassword'
      fill_in 'Confirm new password', with: 'JustNewPassword'
      click_button 'Update'
      expect(page).to have_content 'Update successfully!'
    end

    pending 'user can change his profile image' do
      click_link 'Change of profile image'
      click_button 'Update'
      expect(page).to have_content 'Update successfully!'
    end

    it 'user can change his email' do
      click_link 'Change of email'
      fill_in 'New email', with: 'new@email.com'
      click_button 'Update'
      expect(page).to have_content 'Update successfully!'
    end
  end
end
