class FeedbackMailer < ActionMailer::Base

  default :from => "mailer@spiderlist.org"
  default :to => "crypticsymbols@gmail.com"

  def new_feedback(message)

    @message = message

    mail(:subject => "Spiderlist feedback")
  end

end
