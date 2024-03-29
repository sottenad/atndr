class MapController < ApplicationController
	require 'geocoder'

  def index

  	@json = Event.where("startdate >= ?", Date.today.to_date).order("time ASC").to_gmaps4rails do |event, marker|
  	 similar = Event.where("latitude = ? AND longitude = ?", event.latitude, event.longitude)
     marker.infowindow render_to_string(:partial => "/map/infowindow", :locals => { :object => event, :similar => similar})
     marker.json({ :id => event.id }) 	 
	end
	@userlocation = request.location.city
	@events1 = Event.all


  end
def gmaps4rails_infowindow

end

end
