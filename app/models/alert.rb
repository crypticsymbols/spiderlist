class Alert < ActiveRecord::Base

  belongs_to :user

  validates_numericality_of :run_every, :greater_than => 3599

  validates_numericality_of :price_min, :greater_than => 0, :allow_blank => true

  validates_numericality_of :price_max, :greater_than => 0, :allow_blank => true

def self.mailer

	require 'Tap'

	now = DateTime.now

	alerts = Alert.where('scheduled_time < ?', now)

	alerts.each do |a|

		last_run = a.scheduled_time - a.run_every.seconds

		tap = Tap.new

		tap.build_query(a, last_run.to_i)

	    results = tap.make_request

	    # puts 'hello'

		if (results['num_matches'] > 0)

			user = User.find(a.user_id)
			message = Array.new

			# puts a.inspect
			
			title = 'Spiderlist results '
			if (!a.terms.blank?)
				title << 'for '+a.terms
			end

			if (!a.zipcode.blank?)
				title << ' near '+a.zipcode
			end

			results['postings'].each do |r|

		    	row = {'source' => r['source'], 
		    		'url' => r['external_url'], 
		    		'price' => r['price'],
		    		'timestamp' => Time.at(r['timestamp']).in_time_zone(user.time_zone).strftime('%m/%d/%Y at %I:%M%p'),
		    		'title' => r['heading'],
		    		'address' => r['location']['formatted_address']}
		    	message << row
		    end

		    if (results['num_matches'] > 10)
		    	additional = results['num_matches'].to_i - 10
		    	footer = "... and " + additional.to_s + " more results "
		    end

			a.scheduled_time = now + a.run_every.seconds
			a.save

			email = AlertMailer.send_alert_email(user, message, title, footer, a)

			email.deliver

			puts email.to_s

		end

	end

  end
  
end
