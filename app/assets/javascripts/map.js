// var serviceurl = '/filters/index?json&';
// var lastSong = null;
// var currentSong = null;
// var searchDist;
// 
// $(function(){
//   
//  $('#dateFilter').slider({
//        min: 0,
//        max: 5,
//        step: 1,
//        value: 0,
//        slide: function(event, ui) {
//          updateMap();
//        }
//      });
//      
//   var distance = [1,2,5,10,15];
//  $('#distFilter').slider({
//        min: 0,
//        max: 4,
//        step: 1,
//        value: 0,
//        slide: function(event, ui) {
//          updateMap();
//          searchDist = distance[ui.value];
//        }
//    });
//      
//  var gmap = Gmaps.map.map;
//  var currentShow = 0;
// 
//  $('.nextshow').live('click', function(){
//    var total = $('.showDetails').length;
//    if(currentShow+1 < total){
//      currentShow++
//      $('.showDetails').hide();
//      $('.showDetails').eq(currentShow).show();
//    }else{
//      currentShow = 0;
//      $('.showDetails').hide();
//      $('.showDetails').eq(0).show();
//    }
//    $('.currentshow').text(currentShow+1);
//    
//  });
//  
//  $('.playsong').live('click', function(){
//    playSong(this);
//  })
//  
//   $("#dateFilter, #distFilter").live('change', function(){
//    updateMap();
//   });
// 
//  if (navigator.geolocation) {
//      //navigator.geolocation.getCurrentPosition(successFunction, errorFunction);
//  } 
//  //Get the latitude and the longitude;
//  function successFunction(position) {
//    
//      var lat = position.coords.latitude;
//      var lng = position.coords.longitude;
//      var point = new google.maps.LatLng(lat, lng);
//    Gmaps.map.map.setCenter(point);
//    Gmaps.map.map.setZoom(11);
//  }
//  
//  function errorFunction(){
//      alert("Geocoder failed");
//  } 
// 
// });
// 
// 
// //Fired from the view on gmaps4rails creation.
// function gmapsCallback(){
//  Gmaps.map.map_options.auto_zoom = false;
//  Gmaps.map.map_options.auto_adjust = false;
// 
//  var userLocation = '<%= @userlocation %>';
//  if(userLocation != ''){
//    var geocoder = new google.maps.Geocoder();
//    geocoder.geocode({
//        'address': userLocation
//    }, function(responses) {
//        if (responses && responses.length > 0) {
//            alert(responses[0].formatted_address);
//        } else {
//          //alert('Cannot determine address at this location.');
//        }
//      });
//    }else{
//    var res = prompt('Enter City');
//    var geocoder = new google.maps.Geocoder();
//    geocoder.geocode({
//      'address': res
//    }, function(responses) {
//        if (responses && responses.length > 0) {
//            var lat = responses[0].geometry.location.$a;
//            var lng  = responses[0].geometry.location.ab;           
//            var point = new google.maps.LatLng(lat, lng);
//        Gmaps.map.map.setCenter(point);
//        Gmaps.map.map.setZoom(13);
// 
//        } else {
//          alert('Cannot determine address at this location.');
//        }
//      });
//    }
// }
// 
// 
// 
// //This grabs parameters from throughout the ui and the map and fires off a request to filters/json/ 
// // to get a new list of shows, then passes that to gmaps.map.replaceMarkers();
// function updateMap(){
//    //Construct url
//    var lat = Gmaps.map.map.center.$a;
//    var long = Gmaps.map.map.center.ab;
//     var future = $('#dateFilter').slider('value');
//     var dist = searchDist;
//    var qs = 'lat='+lat+'&long='+long+'&dist='+dist+'&future='+future;
//    var totalUrl = serviceurl+qs;
//    var new_markers = $.getJSON(totalUrl, function(data) {
//      Gmaps.map.replaceMarkers(data);
//    });
//    
//    //Update UI
//    var today = new Date();
//    var cutoffDate = new Date();
//    cutoffDate.setDate(today.getDate() + parseInt(future) );
//     $('#displayDateVal').text((cutoffDate.getMonth()+1)+'-'+cutoffDate.getDate());
//     $('#displayDistVal').text(dist);
// }
// 
// //This is called from the .live event attached to play buttons in the infowindow, it simply passes
// // all the relevent information from the data parameters on the element to soundmanager.
// function playSong(item){
//  var songurl = $(item).attr('data-songurl');
//  var songname = $(item).attr('data-songname');
//  var songid = songname.replace(/\s/g, "");
//  songid = songid.toLowerCase();
//  
//  //Now Create that song in soundmanager. 
//  var existingSong = soundManager.getSoundById(songname);
//  if(existingSong == null){
//    //No song in system, create new one
//     var newSong = soundManager.createSound({
//      id: songid,
//      url: songurl,
//      autoLoad: true,
//      autoPlay: false,
//      playNext:true,
//      volume: 50
//    });
//    newSong.songtitle = songname;
//    if(lastSong != null){
//      if(lastSong._iO.id != undefined){
//          //soundManager.stop(lastSong._iO.id);
//          console.log(lastSong._iO.id)
//          var smlast = soundManager.getSoundById(lastSong._iO.id);
//          smlast.unload();
//      }
//      }
//      newSong.play({
//        onplay:function(){
//          updatePlayer(this)
//        }
//      });
//      lastSong = newSong; 
//  }else{
//    //We've played this song before, just play it.
//    if(lastSong != null){
//      lastSong.stop();
//      lastSong.unload();
//    }
//    existingSong.play();
//    lastSong = existingSong();
//  }
//    
// }
// 
// 
// function updatePlayer(sound){
//  var sm = sound;
//  var playerUi = $('.player');
//  var playpause = $(playerUi).find('.playpause');
//  var playername = $(playerUi).find('.name').text(sound.songtitle);
//  var playershow = $(playerUi).find('.show');
//  
//  $(playpause).live('click', function(){
//    lastSong.togglePause();
//  });
// }
// 
// 
