class MapController < ApplicationController


  def index

  	@json = Event.all.to_gmaps4rails do |event, marker|
 	 marker.json({ :id => event.id })
	end

  end
def gmaps4rails_infowindow

end

end
