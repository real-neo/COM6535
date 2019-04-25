require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @user=FactoryBot.create(:user)
    UserMailer.block_user_mailer(@user).deliver
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end


  describe 'when a user is blocked' do

    it 'an email should be send to the user' do

      ActionMailer::Base.deliveries.count.should == 1
    end

    it 'renders the receiver email' do
      ActionMailer::Base.deliveries.first.to.should == [@user.email]
    end

    it 'should set the subject to the correct subject' do
      ActionMailer::Base.deliveries.first.subject.should == 'Account blocked'
    end

    it 'renders the sender email' do
      ActionMailer::Base.deliveries.first.from.should == ['team12Genesys@gmail.com']
    end


  end

end


