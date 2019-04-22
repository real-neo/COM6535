# frozen_string_literal: true

require 'rspec'
require 'rails_helper'

describe 'Forum' do
  context 'When I am at the Exercise page' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:post) { FactoryBot.create(:post, user: user) }

    before(:each) do
      visit posts_path(forum_type: 'Exercise')
    end

    it 'should see the title Exercise Section' do
      expect(page).to have_content 'Exercise section'
    end

    it 'should see a button to create a post' do
      expect(page).to have_content 'Create Post'
    end

    it 'should see a button to create a poll' do
      expect(page).to have_content 'Create Poll'
    end

    it 'I can see a view button for a post' do
      expect(page).to have_content 'View'
    end

    it 'when I press the view link I should redirect to a page with the post and its comments' do
      expect(page).to_not have_content 'Reply'
      click_link 'View'
      expect(page).to have_content 'My Title'
      expect(page).to have_content 'My Description'
      expect(page).to have_content 'Reply'
    end
  end

  context 'As a logged in user', js: true do
    let!(:user) { FactoryBot.create(:user) }
    let!(:post) { FactoryBot.create(:post, user: user) }

    before(:each) do
      login_as user
      visit posts_path(forum_type: 'Exercise')
    end

    it 'when I press the button to create a post I should see a popup' do
      click_link 'Create Post'
      expect(page).to have_content 'Create a Post'
    end

    pending 'when I press the button to create a poll I should see a popup' do
      click_link 'Create Poll'
      expect(page).to have_content 'Create a Poll'
    end

    it 'when I fill in the popup I should be able to post a new thread and see it on the page' do
      click_link 'Create Post'
      fill_in 'Title', with: 'New Post'
      fill_in 'Description', with: 'Describing the post'
      click_button 'Submit'
      expect(page).to have_content 'New Post'
      expect(page).to have_content 'Describing the post'
    end

    it 'when I press the reply button I should see a pop up that allows me to submit my comment' do
      visit post_path(post)
      click_link 'Reply'
      fill_in 'Comment', with: 'My reply'
      click_button 'Submit'
      expect(page).to have_content 'Your comment has been submitted!'
      expect(page).to have_content 'My reply'
    end

    it 'when I press the reply button on a comment I should see a pop up that allows me to reply to it' do
      reply = FactoryBot.create(:reply, user: user, post: post)
      visit post_path(post)
      find("[href='/replies/1/show_reply_modal?is_post=0']").click
      fill_in 'Comment', with: 'My reply'
      click_button 'Submit'
      expect(page).to have_content 'Your comment has been submitted!'
      expect(page).to have_content 'MyString'
    end

    it 'when I press the reply button on a reply to a comment I should see a pop up that allows me to reply to it' do
      reply1 = FactoryBot.create(:reply, user: user, post: post)
      reply2 = FactoryBot.create(:reply, user: user, post: post, original: reply1)

      visit post_path(post)
      find("[href='/replies/2/show_reply_modal?is_post=0']").click
      fill_in 'Comment', with: 'My reply'
      click_button 'Submit'
      expect(page).to have_content 'Your comment has been submitted!'
      expect(page).to have_content 'MyString'
    end

    it 'when I press the reply button I should see a pop up that allows me to submit my comment' do
      visit post_path(post)
      click_link 'Reply'
      within('#modal_placeholder') do
        expect(page).to have_content 'Comment'
      end
    end

    it 'when I press the like button on a post I should see a notification confirming it and increase the like count' do
      visit '/posts'
      expect(page).to have_content '0 Likes'
      click_link 'like_icon'
      expect(page).to have_content 'Your vote has been submitted!'
      expect(page).to have_content '1 Like'
    end

    it 'when I press the like button on a post that I liked my vote should be removed' do
      FactoryBot.create(:like, user: user, post: post)
      visit '/posts'
      expect(page).to have_content '1 Like'
      click_link 'like_icon'
      expect(page).to have_content 'Your vote has been removed!'
      expect(page).to have_content '0 Likes'
    end

    it 'when I press the dislike button on a post I should see a notification confirming it and increase the dislike count' do
      visit '/posts'
      expect(page).to have_content '0 Dislikes'
      click_link 'dislike_icon'
      expect(page).to have_content 'Your vote has been submitted!'
      expect(page).to have_content '1 Dislike'
    end

    it 'when I press the like button on a post that disliked my vote should be removed' do
      FactoryBot.create(:like, user: user, post: post, like: false)
      visit '/posts'
      expect(page).to have_content '1 Dislike'
      click_link 'dislike_icon'
      expect(page).to have_content 'Your vote has been removed!'
      expect(page).to have_content '0 Dislikes'
    end

    it 'when I press the report button I should see a pop up that allows me to submit my report' do
      visit 'posts'
      click_link 'Report'
      fill_in 'Reason', with: 'My reason'
      click_button 'Submit'
      expect(page).to have_content 'Your report has been submitted!'
    end

    it 'when I go to the report page I should see reports' do
      FactoryBot.create(:report, user: user, post: post)
      user.admin = true
      visit 'reports'
      expect(page).to have_content 'Reporting reason'
    end

    it 'when I go to the report page I should see reports and be able to delete them as an admin' do
      FactoryBot.create(:report, user: user, post: post)
      user.admin = true
      visit 'reports'
      click_link 'Delete'
      expect(page).to have_content 'Thread content deleted successfully.'
    end

    context 'When I am at a thread that I posted' do
      before(:each) do
        visit post_path(post)
      end

      it 'I can see a report button for a post' do
        expect(page).to have_content 'Report'
      end

      it 'I should be able to see a delete button' do
        expect(page).to have_content 'Delete'
      end

      it 'I should be able to delete it' do
        click_link 'Delete'
        expect(page).to have_content 'Thread content deleted successfully.'
      end
    end
  end

  context 'As a not logged in user', js: true do
    let!(:user) { FactoryBot.create(:user) }
    let!(:post) { FactoryBot.create(:post, user: user) }

    it 'when I press the button to create I should see a flash message telling me to log in' do
      visit posts_path(forum_type: 'Exercise')
      click_link 'Create Post'
      expect(page).to have_content 'Please log in to continue'
    end

    it 'when I press the reply button I should see a flash message telling me to log in' do
      visit post_path(post)
      click_link 'Reply'
      expect(page).to have_content 'Please log in to continue'
    end

    pending 'when I press the report button I should see a flash message telling me to log in' do
      visit post_path(post)
      click_link 'Report'
      expect(page).to have_content 'Please log in to continue'
    end
  end
end
