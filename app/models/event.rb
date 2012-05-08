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
  		l=(b.length-3).to_s
  		band << ', '+l+' more...'
  	end
  	
		listing += "<div class='"
    #if has songs, show headphones class
		if self.songs.length > 0
		  listing += " hassongs"
	  end
	  if b.length == 0
  		listing += " singleact" 
  	end
    listing += " listing'><span class='headliner'>#{headliner}</span>"
    #if has supporting acts, list them
    if b.length > 0
  		listing += "<p class='acts'>#{band}</p>" 
  	end
  	return listing
  end
end