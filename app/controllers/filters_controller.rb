class FiltersController < ApplicationController

	
	def index
		lat = params['lat']
		long = params['long']
		dist = params['dist']
		future = Integer(params['future'])
		
		result = 
		
		json = Event.near([lat, long], Integer(params['dist'])).where("startdate <= ? AND startdate > ? ", Date.today + future, Date.today-1)
		@result = json.to_gmaps4rails do |event, marker|
	  	 similar = Event.where("latitude = ? AND longitude = ?", event.latitude, event.longitude)
	     marker.infowindow render_to_string(:partial => "/map/infowindow", :locals => { :object => event, :similar => similar})
	
	     marker.json({ :id => event.id })
	 	  	 
		end
			
		render :json => @result

	end
	

end
