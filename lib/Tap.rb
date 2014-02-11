class Tap

	require 'net/http'
	require 'json'

	# REDACTED
	API_URL = "search.3taps.com"

	def initialize
		# @query = 'ohai'
	end

	def build_query(alert, timestamp = 0, page = nil)

		query = '/?auth_token='+AUTH_TOKEN

		query << "&retvals=price,heading,source,external_url,location,timestamp"

		if (!alert.category.blank?)
			
			if (alert.category =~ /(.)\1{3,}/)
				query << '&category_group='
			else
				query << '&category='
			end

			query << alert.category

		end

		# This will need to get replaces with latlong
		if ((!alert.lat.blank?) && (!alert.long.blank?))
			query << '&lat=' + alert.lat.to_s
			
			query << '&long=' + alert.long.to_s

			if (!alert.radius.blank?)
				query << '&radius=' + alert.radius.to_s + 'mi'
			end

		end

		if (!alert.terms.blank?)

			if (alert.terms.include? ",")
				term_array = alert.terms.split(', ')
				term_array.collect! { |item|
					item = '"'+item+'"'
				}
				terms = term_array.join('|')
			else
				terms = alert.terms
			end
			query << '&text=' + terms

		end

		if (!alert.price_min.blank? or !alert.price_max.blank?)
			query << '&price='
			if (!alert.price_min.blank?)
				query << alert.price_min.to_s
			end
			query << '..'
			if (!alert.price_max.blank?)
				query << alert.price_max.to_s
			end
		end

		if (!page.nil?)
			query << '&page=' + page.to_s
		end

		query << "&timestamp=" + timestamp.to_s + ".."

		query << '&sort=-timestamp'

		@query = URI.escape(query)

		return query

		# puts @query

	end

	def get_query
		return @query
	end

	def make_request
		response = Net::HTTP.get_response(API_URL, @query)
		json = JSON.parse(response.body) ##this must show the JSON contents
		return json
		# return @query # to debug query
	end

	def categories
		categories = {
			"All Vehicles" => "VVVV",
		    "- Vehicles - Autos" => "VAUT",
		    "- Vehicles - Other" => "VOTH",
		    "- Vehicles - Parts" => "VPAR",
			"For Sale - All" => "SSSS",
		    "- For Sale - Creative" => "SVCC",
		    "- For Sale - Education" => "SVCE",
		    "- For Sale - Financial" => "SVCF",
		    "- For Sale - Health" => "SVCM",
		    "- For Sale - Household" => "SVCH",
		    "- For Sale - Other" => "SVCO",
		    "- For Sale - Professional" => "SVCP",
		    "- For Sale - Antiques" => "SANT",
		    "- For Sale - Apparel" => "SAPP",
		    "- For Sale - Appliances" => "SAPL",
		    "- For Sale - Art & Crafts" => "SANC",
		    "- For Sale - Babies & Kids" => "SKID",
		    "- For Sale - Barters" => "SBAR",
		    "- For Sale - Bicycles" => "SBIK",
		    "- For Sale - Businesses" => "SBIZ",
		    "- For Sale - Collections" => "SCOL",
		    "- For Sale - Educational" => "SEDU",
		    "- For Sale - Electronics & Photo" => "SELE",
		    "- For Sale - Food & Beverage" => "SFNB",
		    "- For Sale - Furniture" => "SFUR",
		    "- For Sale - Gift Cards" => "SGFT",
		    "- For Sale - Health & Beauty" => "SHNB",
		    "- For Sale - Home & Garden" => "SHNG",
		    "- For Sale - Industrial" => "SIND",
		    "- For Sale - Jewelry" => "SJWL",
		    "- For Sale - Literature" => "SLIT",
		    "- For Sale - Movies & Music" => "SMNM",
		    "- For Sale - Musical Instruments" => "SMUS",
		    "- For Sale - Other Goods" => "SOTH",
		    "- For Sale - Restaurants" => "SRES",
		    "- For Sale - Services" => "SVCS",
		    "- For Sale - Sports & Fitness" => "SSNF",
		    "- For Sale - Tickets" => "STIX",
		    "- For Sale - Tools" => "STOO",
		    "- For Sale - Toys & Hobbies" => "STOY",
		    "- For Sale - Travel" => "STVL",
		    "- For Sale - Wanted" => "SWNT",
			"Animals - All" => "AAAA",
			"- Animals - Other" => "AOTH",
		    "- Animals - Pets" => "APET",
		    "- Animals - Supplies" => "ASUP",
		    "Community - All" => "CCCC",
		    "- Community - Bulletin" => "COMM",
		    "- Community - Lost & Found" => "CLNF",
		    "- Community - Rideshares" => "CRID",
		    "Dispatch - All" => "DDDD",
		    "- Dispatch - Delivery" => "DDEL",
		    "- Dispatch - Discusssions" => "DISC",
		    "- Dispatch - Taxi" => "DTAX",
		    "- Dispatch - Tow" => "DTOW",
		    "All Jobs" => "JJJJ",
		    "- Jobs - Accounting" => "JACC",
		    "- Jobs - Administrative" => "JADM",
		    "- Jobs - Aerospace & Defense" => "JAER",
		    "- Jobs - Analyst" => "JANL",
		    "- Jobs - Animals & Agriculture" => "JANA",
		    "- Jobs - Architecture" => "JARC",
		    "- Jobs - Art" => "JART",
		    "- Jobs - Automobile" => "JAUT",
		    "- Jobs - Beauty" => "JBEA",
		    "- Jobs - Business Development" => "JBIZ",
		    "- Jobs - Computer & Web" => "JWEB",
		    "- Jobs - Construction & Facilities" => "JCST",
		    "- Jobs - Consulting" => "JCON",
		    "- Jobs - Customer Service" => "JCUS",
		    "- Jobs - Design" => "JDES",
		    "- Jobs - Education" => "JEDU",
		    "- Jobs - Energy" => "JENE",
		    "- Jobs - Engineering" => "JENG",
		    "- Jobs - Entertainment & Media" => "JENT",
		    "- Jobs - Finance" => "JFIN",
		    "- Jobs - Food & Beverage" => "JFNB",
		    "- Jobs - Gigs" => "JGIG",
		    "- Jobs - Government" => "JGOV",
		    "- Jobs - Healthcare" => "JHEA",
		    "- Jobs - Hospitality & Travel" => "JHOS",
		    "- Jobs - Human Resources" => "JHUM",
		    "- Jobs - Installation" => "JMNT",
		    "- Jobs - Insurance" => "JINS",
		    "- Jobs - International" => "JINT",
		    "- Jobs - Law Enforcement" => "JLAW",
		    "- Jobs - Legal" => "JLEG",
		    "- Jobs - Management & Directorship" => "JMAN",
		    "- Jobs - Manufacturing & Mechanical" => "JMFT",
		    "- Jobs - Marketing" => "JMAR",
		    "- Jobs - NonProfit" => "JNON",
		    "- Jobs - Operations & Logistics" => "JOPS",
		    "- Jobs - Other" => "JOTH",
		    "- Jobs - Pharmaceutical" => "JPHA",
		    "- Jobs - Product" => "JPRO",
		    "- Jobs - Purchasing" => "JPUR",
		    "- Jobs - Quality Assurance" => "JQUA",
		    "- Jobs - Real Estate" => "JREA",
		    "- Jobs - Recreation" => "JREC",
		    "- Jobs - Resumes" => "JRES",
		    "- Jobs - Retail & Wholesale" => "JRNW",
		    "- Jobs - Sales" => "JSAL",
		    "- Jobs - Science" => "JSCI",
		    "- Jobs - Security" => "JSEC",
		    "- Jobs - Skilled Trade & General Labor" => "JSKL",
		    "- Jobs - Telecommunications" => "JTEL",
		    "- Jobs - Transportation" => "JTRA",
		    "- Jobs - Volunteer" => "JVOL",
		    "- Jobs - Writing & Publishing" => "JWNP",
		    "All Personals" => "PPPP",
		    "- Personals - Men Seeking Men" => "PMSM",
		    "- Personals - Men Seeking Women" => "PMSW",
		    "- Personals - Other" => "POTH",
		    "- Personals - Women Seeking Men" => "PWSM",
		    "- Personals - Women Seeking Women" => "PWSW",
		    "Real Estate - All" => "RRRR",
		    "- Real Estate - Commercial Real Estate" => "RCRE",
		    "- Real Estate - Housing & Apartments For Rent" => "RHFR",
		    "- Real Estate - Housing For Sale" => "RHFS",
		    "- Real Estate - Housing & Apartment Sublets" => "RSUB",
		    "- Real Estate - Housing & Apartments Swaps" => "RSWP",
		    "- Real Estate - Lots & Land" => "RLOT",
		    "- Real Estate - Other" => "ROTH",
		    "- Real Estate - Parking & Storage" => "RPNS",
		    "- Real Estate - Room Shares" => "RSHR",
		    "- Real Estate - Vacation Properties" => "RVAC",
		    "- Real Estate - Want Housing" => "RWNT"
	    }
	end

	def radii
		radii = {
			"5 Miles" => "5",
		    "10 Miles" => "10",
		    "25 Miles" => "25",
		    "50 Miles" => "50",
		    "100 Miles" => "100",
		    "250 Miles" => "250",
		    "500 Miles" => "500",
		    "Entire USA" => "4000"
	    }
	end

	def time_options
		radii = {
			"Every Hour!" => "3600",
		    "Twice a day" => "43200",
		    "Once a day" => "86400",
		    "Every other day" => "172800",
		    "Once a week" => "604800"
	    }
	end

end

# http://search.3taps.com/?auth_token=31567c070f36a6a3f76cfe72b33e21f6&location.zipcode=USA-05301&radius=20mi