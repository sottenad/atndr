class MapController < ApplicationController


  def index

  	@json = Event.all.to_gmaps4rails do |event, marker|
  	 similar = Event.where("latitude = ? AND longitude = ?", event.latitude, event.longitude)
     marker.infowindow render_to_string(:partial => "/map/infowindow", :locals => { :object => event, :similar => similar})
	
     marker.json({ :id => event.id })
 	  	 
	end
	
	@events = Event.all


  end
def gmaps4rails_infowindow

end

end
