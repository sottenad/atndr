class Event < ActiveRecord::Base

  geocoded_by :location
  after_validation :geocode
  acts_as_gmappable


	def gmaps4rails_address
	#describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
	  "#{self.location}" 
	end

def gmaps4rails_sidebar
  "<span>#{bands}</span>" 
end
 
	def getiTunes
		itunesMarkup = ''
		itunes = ITunes::Client.new
	  	songs = itunes.music('green day', :limit => 3)
	  	songs.results.each do |song|
	  	
	  		itunesMarkup << song.preview_url + ' <br /> '
	  	end
	  	return itunesMarkup
	end
	
end
