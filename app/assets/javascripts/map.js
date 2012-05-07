var serviceurl = '/filters/index?json&';

$(function(){
	
	var currentShow = 0;

	$('.nextshow').live('click', function(){
		var total = $('.showDetails').length;
		if(currentShow+1 < total){
			currentShow++
			$('.showDetails').hide();
			$('.showDetails').eq(currentShow).show();
		}else{
			currentShow = 0;
			$('.showDetails').hide();
			$('.showDetails').eq(0).show();
		}
		$('.currentshow').text(currentShow+1);
		
	});
	
	$('.playsong').live('click', function(){
		playSong(this);
	})
	
	
	$("#dateFilter, #distFilter").live('change', function(){
		updateMap();
	});
	
	if (navigator.geolocation) {
	    //navigator.geolocation.getCurrentPosition(successFunction, errorFunction);
	} 
	//Get the latitude and the longitude;
	function successFunction(position) {
		
	    var lat = position.coords.latitude;
	    var lng = position.coords.longitude;
	    var point = new google.maps.LatLng(lat, lng);
		Gmaps.map.map.setCenter(point);
		Gmaps.map.map.setZoom(11);
	}
	
	function errorFunction(){
	    alert("Geocoder failed");
	}	

});

//This grabs parameters from throughout the ui and the map and fires off a request to filters/json/ 
// to get a new list of shows, then passes that to gmaps.map.replaceMarkers();
function updateMap(){
		//Construct url
		var lat = Gmaps.map.map.center.$a;
		var long = Gmaps.map.map.center.ab;
		var future = $('#dateFilter').val();
		var dist = $('#distFilter').val();
		var qs = 'lat='+lat+'&long='+long+'&dist='+dist+'&future='+future;
		var totalUrl = serviceurl+qs;
		var new_markers = $.getJSON(totalUrl, function(data) {
			Gmaps.map.replaceMarkers(data);
		});
		
		//Update UI
		var today = new Date();
		var cutoffDate = new Date();
		cutoffDate.setDate(today.getDate() + parseInt(future)	);
		$('#displayDateVal').text((cutoffDate.getMonth()+1)+'-'+cutoffDate.getDate());
		$('#displayDistVal').text(dist);
}

//This is called from the .live event attached to play buttons in the infowindow, it simply passes
// all the relevent information from the data-WHATEVER parameters on the element to soundmanager.
function playSong(item){
	var songurl = $(item).attr('data-songurl');
	var songname = $(item).attr('data-songname');
	//Now Create that song in soundmanager.
	 var newSong = soundManager.createSound({
	  id: songname,
	  url: songurl,
	  autoLoad: true,
	  autoPlay: false,
	  onload: function() {
	    this.play();
	  },
	  volume: 50
	});
		
}

