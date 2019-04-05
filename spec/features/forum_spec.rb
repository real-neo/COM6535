require 'rspec'
require 'rails_helper'

describe 'Forum' do
  context 'When I am at the Exercise page' do
    before(:each) do
      visit '/posts'
    end

    it 'should see the title Exercise Section' do
      expect(page).to have_content "Exercise Section"
    end

    it 'should see a button to create a post' do
      expect(page).to have_content "Create Post"
    end

    it 'should see a button to create a poll' do
      expect(page).to have_content "Create Poll"
    end

    context 'As a logged in user' do
      it 'when I press the button to create a post I should see a popup' do
        click_link "Create Post"
        expect(page).to have_content "Create a Post"
      end

      # it 'when I press the popup I should be apble to close it by pressing X' do
      #   click_link "Create Post"
      #   expect(page).to have_content "Exercise Section"
      # end

      it 'when I fill in the popup I should be able to post a new thread and see it on the page' do
        click_link "Create Post"
        fill_in('Title', with: "New post")
        fill_in('Description', with: "Describing the post")
        click_button "Save Post"
        expect(page).to have_content "New Post"
        expect(page).to have_content "Describing the post"
      end

    end

  end
end
