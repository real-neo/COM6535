class UserMailer < ApplicationMailer
  default from: 'team12Genesys@gmail.com'
  layout 'mailer'

  def block_user_mailer(user)
    @user = user
    mail(to: user.email, subject: 'Account blocked')
  end
end
