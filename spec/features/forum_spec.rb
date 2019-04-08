require 'rspec'
require 'rails_helper'

describe 'Forum' do
  context 'When I am at the Exercise page', js:true do
    before(:each) do
      visit '/posts'
    end

    it 'should see the title Exercise Section' do
      expect(page).to have_content "Exercise Community"
    end

    it 'should see a button to create a post' do
      expect(page).to have_content "Create Post"
    end

    it 'should see a button to create a poll' do
      expect(page).to have_content "Create Poll"
    end

    it ' i can see a view button for a post' do
      user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, user: user)
      visit '/'
      visit '/posts'
      expect(page).to have_content "View"
    end

    it 'when i press the view button i should redirect to a page with the post and its comments' do
      user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, user: user)
      visit '/'
      visit '/posts'
      expect(page).to_not have_content "Reply"
      click_link 'View'
      expect(page).to have_content "My Title"
      expect(page).to have_content "My Description"
      expect(page).to have_content "Reply"
    end


    context 'As a logged in user' do
      before(:each) do
        user = FactoryBot.create(:user, email: 'aioannou2@sheffield.ac.uk', password: 'qweqweqwe')
        login_as(user, :scope => :user)
        visit '/'
        visit '/posts'
      end

      it 'when I press the button to create a post I should see a popup' do
        click_link "Create Post"
        expect(page).to have_content "Create a Post"
      end

      it 'when I fill in the popup I should be able to post a new thread and see it on the page' do
        click_link "Create Post"
        fill_in('post_title', with: "New Post")
        fill_in('post_description', with: "Describing the post")
        click_button "Submit"
        expect(page).to have_content "New Post"
        expect(page).to have_content "Describing the post"
      end


      # it 'when I press the button to create a poll I should see a popup' do
      #   click_link "Create Post"
      #   expect(page).to have_content "Create a Poll"
      # end

      it 'when I press the reply button I should see a pop up that allows me to submit my comment' do
        user = FactoryBot.create(:user)
        post = FactoryBot.create(:post, user: user)
        visit '/'
        visit '/posts'
        click_link 'View'
        click_link 'Reply'
        fill_in('reply_comment',with: "My reply")
        click_button 'Submit'
        expect(page).to have_content "Your comment has been submitted!"
        expect(page).to have_content "My reply"
      end

      it 'when I press the reply button on a comment I should see a pop up that allows me to reply to it' do
        user = FactoryBot.create(:user)
        post = FactoryBot.create(:post, user: user)
        reply = FactoryBot.create(:reply, user: user, post: post)
        visit '/'
        visit '/posts'
        click_link 'View'
        find("[data-target='#reply_modal_1']").click
        fill_in('reply_comment',with: "My reply")
        click_button 'Submit'
        expect(page).to have_content "Your comment has been submitted!"
        expect(page).to have_content "MyString"
      end


      it 'when I press the reply button on a reply to a comment I should see a pop up that allows me to reply to it' do
        user = FactoryBot.create(:user)
        post = FactoryBot.create(:post, user: user)
        reply1 = FactoryBot.create(:reply, user: user, post: post)
        reply2 = FactoryBot.create(:reply, user: user, post: post, original: reply1)

        visit '/'
        visit '/posts'
        click_link 'View'
        find("[data-target='#reply_modal_2']").click
        fill_in('reply_comment',with: "My reply")
        click_button 'Submit'
        expect(page).to have_content "Your comment has been submitted!"
        expect(page).to have_content "MyString"
      end

      it 'when I press the reply button I should see a pop up that allows me to submit my comment' do
        user = FactoryBot.create(:user)
        post = FactoryBot.create(:post, user: user)
        visit '/'
        visit '/posts'
        click_link 'View'
        click_link 'Reply'
        expect(page).to have_content "Submit"
      end

      # it ' i can see a report button for a post' do
      #   user = FactoryBot.create(:user)
      #   post = FactoryBot.create(:post, user: user)
      #   expect(page).to have_button "Report"
      # end


    end

    context 'As a not logged in user' do
      it 'when I press the button to create I should see a flash message telling me to log in' do
        click_link "Create Post"
        expect(page).to have_content "Log in to be able to post"
      end

      it 'when I press the reply button I should see a flash message telling me to log in' do
        user = FactoryBot.create(:user)
        post = FactoryBot.create(:post, user: user)
        visit '/'
        visit '/posts'
        click_link 'View'
        click_link 'Reply'
        expect(page).to have_content "Log in to be able to reply"
      end

      # it 'when I press the report button I should see a flash message telling me to log in' do
      #   user = FactoryBot.create(:user)
      #   post = FactoryBot.create(:post, user: user)
      #   expect(page).to have_button "Report"
      # end

    end
  end
end
