module AlertsHelper

	require 'net/http'
	require 'json'
	
	def geocode
	    response = Net::HTTP.get_response("maps.googleapis.com","/maps/api/geocode/json?address="+self.zipcode.to_s+"&sensor=false")
	    json = JSON.parse(response.body) ##this must show the JSON contents
	    if (!json['results'][0].nil?)
	      lat = json['results'][0]['geometry']['location']['lat']
	      long = json['results'][0]['geometry']['location']['lng']
	    end

	    self.lat = lat
	    self.long = long

	    self.save
	end

end
