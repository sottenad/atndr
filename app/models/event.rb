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
    listing =""
  	b = self.bands.split('|')
  	band = ''
  	#remove the first elements and call it headliner
  	headliner = b.shift()	
  	if b.length < 4
  		band = b.join(',').to_s
  	else
  		band = b[0..2].join(',').to_s
  		band << ', more...'
  	end
  	
		listing += "<div"
    #if has songs, show headphones class
		if self.songs.length < 1
		  listing += " class='hassongs'"
	  end
    listing += ">#{headliner}"
    #if has supporting acts, list them
    if b.length > 0
  		listing += "<br><span>#{band}</span>" 
  	end
  	return listing
  end
end