class AlertMailer < ActionMailer::Base

  default from: "mailer@spiderlist.org"

  def send_alert_email(user, items, title, footer, alert)

  		@items = items

  		@footer = footer

  		@alert = alert
	  
		mail :subject => title,
			:to      => user.email,
			:from    => "alerts@spiderlist.org"

	end

end
