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
		
	})
	
	$("#dateFilter, #distFilter").live('change', function(){
		updateMap();
	});
	
	if (navigator.geolocation) {
	    navigator.geolocation.getCurrentPosition(successFunction, errorFunction);
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
		$('#displayDateVal').text(cutoffDate.getMonth()+'-'+cutoffDate.getDate());
		$('#displayDistVal').text(dist);
}