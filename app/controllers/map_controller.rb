class MapController < ApplicationController


  def index

  	@json = Event.all.to_gmaps4rails do |e, marker|
  	 similar = Event.where("latitude = ? AND longitude = ?", e.latitude, e.longitude)
     marker.infowindow render_to_string(:partial => "/map/infowindow", :locals => { :object => e, :similar => similar})

     marker.json({ :id => event.id })
 	  	 
	end
	
	@events1 = Event.all


  end
def gmaps4rails_infowindow

end

end
