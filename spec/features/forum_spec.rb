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
  end
end
