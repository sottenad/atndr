require 'rubygems'
require 'nokogiri'
require 'open-uri'


task :getevents_seattle => [:environment] do

  for i in (1..5) #next 5 days

    basedate = Date.current
    date = (basedate+i).to_s(:db)
	for j in (1..10)	
	    doc = Nokogiri::HTML(
	        open('http://www.thestranger.com/gyrobase/EventSearch?eventSection=3208279&narrowByDate='+date.to_s+'&page='+j.to_s)
	    )
	    nopage = doc.css('.noMatchesFound')
		if(nopage.count == 0)
		
		    doc.css('.EventListing').each do|node|
		      location = ''
		      bands = ''
		      venue = ''
		      lat = ''
		      long = ''
			  starttime = ''
			
			  node.css('.listing').each do|subnode|
			  	st =  subnode.xpath('text()').to_s
			  	starttime = Chronic.parse(st)
			  	puts starttime
			  end
			  			
		      node.css('.listing h3 > a').each do|subnode|
		        bands = subnode.text
		      end
		
		      node.css('.listingLocation').each do|subnode|
		      	venue = subnode.css('a').first().text
		        location =  subnode.xpath('text()').to_s
		      end
		
		
		      if !location.nil?
		        parenLocation = location.split("(")
		        location = parenLocation.first
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
		      
		      sleep(2)
		
		      puts bands.gsub(/\s+/, ' ').strip
		   #   puts location.gsub(/\s+/, ' ').strip
		   #   puts venue
		   #  puts lat
		   #   puts long

		      
		     
		
			     event = Event.create(
			        :bands => bands,
			        :time => date,
			        :location => location,
			        :venue => venue,
			        :latitude => lat,
			        :longitude => long,
			        :starttime => starttime
			     )
			 end #result loop
		else 
		  break
		end #no results
	  end #page loop	
	end  #day loop
  end


desc "Geocode all objects without coordinates."
task :geocodeevents => :environment do

  Event.all.each do |obj|
    obj.geocode
    obj.save
    puts 'geo'
  end
  
end

def extract_phone_number(input)
  if input.gsub(/\D/, "").match
     [$1, $2, $3].join("-")
  end
end


