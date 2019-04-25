# frozen_string_literal: true

require 'rspec'
require 'rails_helper'

describe 'edit user information' do
  let(:user) { FactoryBot.create(:user) }

  context 'when a user has not log in' do
    it 'should redirect to log in page' do
      visit edit_user_path(user.id)
      expect(current_path).to eql(new_user_session_path)
    end
  end

  context 'when a user has logged in' do
    before do
      login_as user
      visit edit_user_path(user.id)
    end

    it 'user can change his details' do
      click_link 'Change of personal details'
      fill_in 'Details', with: 'My new details'
      click_button 'Update details'
      expect(page).to have_content 'Update successfully!'
      # expect(Devise.mailer.deliveries.count).to eq 1
    end

    it 'user can change his password' do
      click_link 'Change of password'
      fill_in 'New password', with: 'JustNewPassword'
      fill_in 'Confirm new password', with: 'JustNewPassword'
      click_button 'Update password'
      expect(page).to have_content 'Update successfully!'
      # expect(Devise.mailer.deliveries.count).to eq 1
      # Devise.mailer.deliveries.first.subject.should == 'Confirmation instructions'
      # Devise.mailer.deliveries.first.from.should == ['team12Genesys@gmail.com']
    end

    it 'user can not change his password with two different new password' do
      click_link 'Change of password'
      fill_in 'New password', with: 'JustNewPassword1'
      fill_in 'Confirm new password', with: 'JustNewPassword2'
      click_button 'Update password'
      expect(page).to have_content 'Operation failed!'
    end

    it 'user can change his profile image' do
      click_link 'Change of profile image'
      attach_file 'user[avatar]', File.join(Rails.root, '/spec/support/avatar.png')
      click_button 'Update image'
      expect(page).to have_content 'Update successfully!'
    end

    it 'user can not upload image when did not choose any file' do
      click_link 'Change of profile image'
      click_button 'Update image'
      expect(page).to have_content 'Operation failed!'
    end

    it 'user can change his email' do
      click_link 'Change of email'
      fill_in 'New email', with: 'new@email.com'
      click_button 'Update email'
      expect(page).to have_content 'Update successfully!'
    end

    it 'user can not change his email to a invalid address' do
      click_link 'Change of email'
      fill_in 'New email', with: 'invalid.email.com'
      click_button 'Update email'
      expect(page).to have_content 'Operation failed!'
    end

    it 'user can delete account' do
      click_link 'Delete Account'
      click_link 'Delete'
      expect(page).to have_content 'Account deleted successfully.'
    end
  end
end
