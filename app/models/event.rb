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
		
		similar = Event.where("latitude = ? AND longitude = ?", self.latitude, self.longitude)
		output << '<span class="prevshow">&laquo;</span><span class="currentshow">1</span> of <span class="totalshows">'+similar.length.to_s+'</span><span class="nextshow">&raquo;</span>'
		
		output << "<div class='showDetailContainer'>"
		similar.each_with_index do |item, i|
			output << '<div class="showDetails" id="item'+i.to_s+'">'
			output << item.bands
			output << '<br />'
			if(!self.starttime.nil?)
				output << item.starttime.to_s
			else
				output << item.time.to_s
			end
			output << '</div>'
		end
		
		output << '</div>'
		

		return output
		
	end
end
