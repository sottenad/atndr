class Event < ActiveRecord::Base
	serialize :songs

  geocoded_by :location
  after_validation :geocode
  acts_as_gmappable


	def gmaps4rails_address
	#describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
	  "#{self.location}" 
	end

def gmaps4rails_sidebar
	b = self.bands.split('|')
	if b.length < 4
		allb = b.join(',')
		"<span>#{allb}</span>" 
	else
		shortb = b[0..2].join(',')
		"<span>#{shortb}, and more...</span>" 
	end
end
 

	
end
