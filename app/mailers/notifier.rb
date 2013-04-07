class Notifier < ActionMailer::Base
  default from: "admin@askrubyist.org"

  def answer_notify_email(answer)
  	@url = "http://127.0.0.1:3000#{question_path(answer.question)}"
  	mail to: answer.question.user.email, subject: 'this is notification for you on your ask-ruby site'
  end

  def user_welcome_email(user)
  	@user = user
  	@url = "http://127.0.0.1:3000"
  	mail to: user.email, subject: 'Welcome to ask-ruby site'
  end
  
end
