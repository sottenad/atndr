require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'itunes'
require 'json'


task :getevents_seattle => [:environment] do

  for i in (0..7) #next 5 days
    basedate = Date.today
    date = (basedate+i).to_s(:db)
	for j in (1..10)	
	    doc = Nokogiri::HTML(
	        open('http://www.thestranger.com/gyrobase/EventSearch?eventSection=3208279&narrowByDate='+date.to_s+'&page='+j.to_s)
	    )
	    puts 'loaded: http://www.thestranger.com/gyrobase/EventSearch?eventSection=3208279&narrowByDate='+date.to_s+'&page='+j.to_s
	    nopage = doc.css('.noMatchesFound')
		if(nopage.count == 0)
		
		    doc.css('.EventListing').each do|node|
		      location = ''
		      bands = ''
		      venue = ''
		      lat = ''
		      long = ''
			  starttime = ''
			  songs = Array.new
			  headliner = ''
			  genre = Array.new

				
			  #Get the start time, and then use chronic to parse the language
			  node.css('.listing').each do|subnode|
			  	st =  subnode.xpath('text()').to_s
			  	starttime = Chronic.parse(st)
			  end
			  
			  #Get the band listing, then turn into pipe delimited list for storage
		      node.css('.listing h3 > a').each do|subnode|
		        bands = subnode.text.gsub(/\s+/, ' ').strip
		        bandArr = bands.split(',')
		        headliner = bandArr[0]
		        #Trim off the annoying titles, indicated with a ':'
		        if !headliner.index(':').nil?
		        	headliner = headliner.slice((headliner.index(':')+1..headliner.length)).strip
		        end
		        bands = bandArr.join('|')
		      end
		      
			  #Get the location by its address, we'll geocode it next	
		      node.css('.listingLocation').each do|subnode|
		      	venue = subnode.css('a').first().text
		        location =  subnode.xpath('text()').to_s
		      end
		
			
	       	  #Be sure we have a location before geocoding
		      if !location.nil?
		        parenLocation = location.split("(")
		        location = parenLocation.first
		        #Strip out phone numbers, this is unique to the source
		        phone2 = /((\(\d{3}\))|(\d{3}-))\d{3}-\d{4}/
		        location = location.gsub(phone2, '')
		        location = location.gsub(/\s+/, ' ').strip
		        
		        #Now Geocode
		        s = Geocoder.search(location) 
		        if !s[0].nil?    
					lat = s[0].latitude
					long = s[0].longitude
				end
		      end

		      
		      #Now get the itunes information about the headliner (3 songs and photo)
		      if !headliner.nil?
		      	songQuery = ITunes.music(headliner.to_s, :limit => 3)
		      	songQuery.results.each do |song|
		      		tmp = Hash.new
		      		tmp['bandname'] = headliner
		      		tmp['songname'] = song.track_name
		      		tmp['songurl'] = song.preview_url
		      		tmp['songimage'] = song.artwork_url_100
		      		songs.push tmp
		      		genre.push song.primary_genre_name
		      	end
		      	
		      	#Strip Out Duplicate Genre's and join
		      	genre = genre.uniq.join(', ')
		      end
		      
		      #We sleep here for 2 seconds to cool down the geocoder. We were ommitting results without this
		      sleep(1)
		      
			  #Create new event in the DB
			  event = Event.find_or_create_by_latitude_and_longitude_and_time(
	     	    :bands => bands,
	  	        :time => date,
			    :location => location,
		        :venue => venue,
		        :latitude => lat,
		        :longitude => long,
		        :starttime => starttime,
				:genre => genre,
				:songs => songs,
				:startdate => date
		     )
		     
		     puts 'added '+headliner

			 end #result loop
		else 
		  break
		end #no results
	  end #page loop	
	end  #day loop
	

	
  end
  
  
task :getevents_lastfm => [:environment] do

	City.all.each do |city|
	puts city.name
	doc = JSON.parse(open("http://ws.audioscrobbler.com/2.0/?method=geo.getevents&lat="+city.latitude.to_s+"&long="+city.longitude.to_s+"&distance=100&api_key=690e1ed3bc00bc91804cd8f7fe5ed6d4&format=json&limit=1000").read)
	events = doc['events']
	
	events['event'].each_with_index do |item, i|
			location = item['venue']['name']
			bands = ''
			if item['artists']['artist'].is_a? Array
				bands =  item['artists']['artist'].join('|')
			else
				bands = item['artists']['artist']
			end
			venue = item['venue']['name']
			lat = item['venue']['location']['geo:point']['geo:lat']
			long = item['venue']['location']['geo:point']['geo:long']			
			starttime = Chronic.parse(item['startDate'])
			songs = Array.new
			headliner = item['artists']['headliner']
			genre = Array.new
			
			#Now get the itunes information about the headliner (3 songs and photo)
			if !headliner.nil?
				songQuery = ITunes.music(headliner.to_s, :limit => 3)
				songQuery.results.each do |song|
				tmp = Hash.new
					tmp['bandname'] = headliner
					tmp['songname'] = song.track_name
					tmp['songurl'] = song.preview_url
					tmp['songimage'] = song.artwork_url_100
					songs.push tmp
					genre.push song.primary_genre_name
				end
				
				#Strip Out Duplicate Genre's and join
				genre = genre.uniq.join(', ')
			end
			
			tmpDate = DateTime.strptime(starttime)
		
			#Create new event in the DB
			event = Event.find_or_create_by_latitude_and_longitude_and_time(
				:bands => bands,
				:time => tmpDate.strftime("%Y-%m-%d"),
				:location => location,
				:venue => venue,
				:latitude => lat,
				:longitude => long,
				:starttime => starttime,
				:genre => genre,
				:songs => songs,
				:startdate => date
			)

			puts headliner
	end #end each item
	
	



	end
	
	

end
  
 
class Nokogiri::XML::Node
  def to_json(*a)
    {"$name"=>name}.tap do |h|
      kids = children.to_a
      h.merge!(attributes)
      h.merge!("$text"=>text) unless text.empty?
      h.merge!("$kids"=>kids) unless kids.empty?
    end.to_json(*a)
  end
end