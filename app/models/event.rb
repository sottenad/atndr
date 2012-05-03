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
	band = ''
	
	if b.length < 4
		band = b.join(',').to_s
	else
		band = b[0..2].join(',').to_s
		band << ', more...'
	end
	
	if self.songs.length < 1
		"<span>#{band}</span>" 
	else
		"<span class='hassongs'>#{band}</span>" 
	end
end
 

	
end
