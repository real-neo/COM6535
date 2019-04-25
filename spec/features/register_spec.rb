require 'rspec'
require 'rails_helper'

describe 'registration', js: true do
  context 'When a new user tries to sign up' do
    it 'they can register a new account' do
      visit '/users/sign_up'
      fill_in('Firstname', with: 'Alexander')
      fill_in('Lastname', with: 'Arnaouzoglou')
      fill_in('Country', with: 'UK')
      fill_in('City', with: 'Sheffield')
      fill_in('Email', with: 'ioannou.alexis95@gmail.com')
      fill_in('Username', with: 'acp18ai')
      fill_in('Password', with: 'qweqweqwe')
      fill_in('Password confirmation', with: 'qweqweqwe')
      click_button 'Join Now!'
      expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
      expect(Devise.mailer.deliveries.count).to eq 1
      Devise.mailer.deliveries.first.subject.should == 'Confirmation instructions'
      Devise.mailer.deliveries.first.from.should == ['team12Genesys@gmail.com']

    end



    it 'A user cannot register a new account without filling in the information' do
      visit '/users/sign_up'
      click_button 'Join Now!'
      expect(page).to have_content 'Please review the problems below:'
    end

    it 'they cannot register an new account with less than 2 character for firstname' do
      visit '/users/sign_up'
      fill_in('Firstname', with: 'A')
      fill_in('Lastname', with: 'Arnaouzoglou')
      fill_in('Country', with: 'UK')
      fill_in('City', with: 'Sheffield')
      fill_in('Email', with: 'ioannou.alexis95@gmail.com')
      fill_in('Username', with: 'acp18ai')
      fill_in('Password', with: 'qweqweqwe')
      fill_in('Password confirmation', with: 'qweqweqwe')
      click_button 'Join Now!'
      expect(page).to have_content 'is too short (minimum is 2 characters)'
    end

    it 'they cannot register an new account with less than 2 character for lastname' do
      visit '/users/sign_up'
      fill_in('Firstname', with: 'Alexander')
      fill_in('Lastname', with: 'A')
      fill_in('Country', with: 'UK')
      fill_in('City', with: 'Sheffield')
      fill_in('Email', with: 'ioannou.alexis95@gmail.com')
      fill_in('Username', with: 'acp18ai')
      fill_in('Password', with: 'qweqweqwe')
      fill_in('Password confirmation', with: 'qweqweqwe')
      click_button 'Join Now!'
      expect(page).to have_content 'is too short (minimum is 2 characters)'
    end

    it 'they cannot register an new account with less than 2 character for country' do
      visit '/users/sign_up'
      fill_in('Firstname', with: 'Alexander')
      fill_in('Lastname', with: 'Arnaouzoglou')
      fill_in('Country', with: 'U')
      fill_in('City', with: 'Sheffield')
      fill_in('Email', with: 'ioannou.alexis95@gmail.com')
      fill_in('Username', with: 'acp18ai')
      fill_in('Password', with: 'qweqweqwe')
      fill_in('Password confirmation', with: 'qweqweqwe')
      click_button 'Join Now!'
      expect(page).to have_content 'is too short (minimum is 2 characters)'
    end

    it 'they cannot register an new account with less than 2 character for city' do
      visit '/users/sign_up'
      fill_in('Firstname', with: 'Alexander')
      fill_in('Lastname', with: 'Arnaouzoglou')
      fill_in('Country', with: 'UK')
      fill_in('City', with: 'S')
      fill_in('Email', with: 'ioannou.alexis95@gmail.com')
      fill_in('Username', with: 'acp18ai')
      fill_in('Password', with: 'qweqweqwe')
      fill_in('Password confirmation', with: 'qweqweqwe')
      click_button 'Join Now!'
      expect(page).to have_content 'is too short (minimum is 2 characters)'
    end

    it 'they cannot register an new account with less than 2 character for username' do
      visit '/users/sign_up'
      fill_in('Firstname', with: 'Alexander')
      fill_in('Lastname', with: 'Arnaouzoglou')
      fill_in('Country', with: 'UK')
      fill_in('City', with: 'Sheffield')
      fill_in('Email', with: 'ioannou.alexis95@gmail.com')
      fill_in('Username', with: 'a')
      fill_in('Password', with: 'qweqweqwe')
      fill_in('Password confirmation', with: 'qweqweqwe')
      click_button 'Join Now!'
      expect(page).to have_content 'is too short (minimum is 2 characters)'
    end

    it 'they cannot register an new account with more than 25 character for firstname' do
      visit '/users/sign_up'
      fill_in('Firstname', with: 'Alexander This is going to be more than 25 characters long')
      fill_in('Lastname', with: 'Arnaouzoglou')
      fill_in('Country', with: 'UK')
      fill_in('City', with: 'Sheffield')
      fill_in('Email', with: 'ioannou.alexis95@gmail.com')
      fill_in('Username', with: 'aer')
      fill_in('Password', with: 'qweqweqwe')
      fill_in('Password confirmation', with: 'qweqweqwe')
      click_button 'Join Now!'
      expect(page).to have_content 'is too long (maximum is 25 characters)'
    end

    it 'they cannot register an new account with more than 25 character for lastname' do
      visit '/users/sign_up'
      fill_in('Firstname', with: 'Alexander')
      fill_in('Lastname', with: 'Arnaouzoglou  This is going to be more than 25 characters long')
      fill_in('Country', with: 'UK')
      fill_in('City', with: 'Sheffield')
      fill_in('Email', with: 'ioannou.alexis95@gmail.com')
      fill_in('Username', with: 'aer')
      fill_in('Password', with: 'qweqweqwe')
      fill_in('Password confirmation', with: 'qweqweqwe')
      click_button 'Join Now!'
      expect(page).to have_content 'is too long (maximum is 25 characters)'
    end

    it 'they cannot register an new account with more than 55 character for country' do
      visit '/users/sign_up'
      fill_in('Firstname', with: 'Alexander')
      fill_in('Lastname', with: 'Arnaouzoglou')
      fill_in('Country', with: 'UK  This is going to be more than 55 characters long test')
      fill_in('City', with: 'Sheffield')
      fill_in('Email', with: 'ioannou.alexis95@gmail.com')
      fill_in('Username', with: 'aer')
      fill_in('Password', with: 'qweqweqwe')
      fill_in('Password confirmation', with: 'qweqweqwe')
      click_button 'Join Now!'
      expect(page).to have_content 'is too long (maximum is 55 characters)'
    end

    it 'they cannot register an new account with more than 25 character for city' do
      visit '/users/sign_up'
      fill_in('Firstname', with: 'Alexander')
      fill_in('Lastname', with: 'Arnaouzoglou')
      fill_in('Country', with: 'UK')
      fill_in('City', with: 'Sheffield This is going to be more than 55 characters long')
      fill_in('Email', with: 'ioannou.alexis95@gmail.com')
      fill_in('Username', with: 'ad')
      fill_in('Password', with: 'qweqweqwe')
      fill_in('Password confirmation', with: 'qweqweqwe')
      click_button 'Join Now!'
      expect(page).to have_content 'is too long (maximum is 25 characters)'
    end

    it 'they cannot register an new account with more than 25 character for username' do
      visit '/users/sign_up'
      fill_in('Firstname', with: 'Alexander')
      fill_in('Lastname', with: 'Arnaouzoglou')
      fill_in('Country', with: 'UK')
      fill_in('City', with: 'Sheffield')
      fill_in('Email', with: 'ioannou.alexis95@gmail.com')
      fill_in('Username', with: 'a This is going to be more than 25 characters long')
      fill_in('Password', with: 'qweqweqwe')
      fill_in('Password confirmation', with: 'qweqweqwe')
      click_button 'Join Now!'
      expect(page).to have_content 'is too long (maximum is 25 characters)'
    end
  end

  context 'When a user has an account' do
    it 'does not allow them to sign up with the same account' do
      FactoryBot.create(:user, email: 'aioannou2@gmail.com')
      visit '/users/sign_up'
      fill_in('Firstname', with: 'Alexander')
      fill_in('Lastname', with: 'Arnaouzoglou')
      fill_in('Country', with: 'UK')
      fill_in('City', with: 'Sheffield')
      fill_in('Email', with: 'aioannou2@gmail.com')
      fill_in('Username', with: 'acp18ai')
      fill_in('Password', with: 'qweqweqwe')
      fill_in('Password confirmation', with: 'qweqweqwe')
      click_button 'Join Now!'
      expect(page).to have_content 'has already been taken'
    end
  end

end