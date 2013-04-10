class Notifier < ActionMailer::Base

  default from: "admin@askrubyist.org"
  default charset: "utf-8"
  default content_type: "text/html"
  
  layout 'mailer'

  def answer_notify_email(answer)
  	@url = "http://127.0.0.1:3000#{question_path(answer.question)}"
  	email = answer.question.user.email
  	mail to: email, subject: 'this is notification for you on your ask-ruby site' unless email.blank?
  end

  def user_welcome_email(user)
  	@user = user
  	@url = "http://127.0.0.1:3000"
  	email = user.email
  	mail to: email, subject: 'Welcome to ask-ruby site' unless email.blank?
  end
  
end
