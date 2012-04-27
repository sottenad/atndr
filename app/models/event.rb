class Event < ActiveRecord::Base

  geocoded_by :location
  after_validation :geocode
  acts_as_gmappable


	def gmaps4rails_address
	#describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
	  "#{self.location}" 
	end
	
	def gmaps4rails_infowindow
		processInfoWindow()
  #		"<b>#{bands}</b><br /><em>#{venue}</em><br /><em>#{starttime}</em>"

	end
	def processInfoWindow
		output = '';
		
		if(self.starttime.length > 0)
			output += self.starttime
		else
			output += self.time
		end
		return output
		
	end
end
