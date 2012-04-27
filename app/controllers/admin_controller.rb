class AdminController < ApplicationController
  def index
    puts 'hi'
  end

  def getshows
    require 'rubygems'
    require 'nokogiri'
    require 'open-uri'

      for i in (2..3)

        basedate = Date.current
        date = (basedate+i).to_s(:db)

        doc = Nokogiri::HTML(
            open('http://www.thestranger.com/gyrobase/EventSearch?eventSection=3208279&narrowByDate=2012-04-0'+i.to_s)
        )

        doc.css('.EventListing').each do|node|
          location = ''
          bands = ''


          node.css('.listing h3 > a').each do|subnode|
            bands = subnode.text
          end

          node.css('.listingLocation').each do|subnode|
            location =  subnode.text
          end

          if !location.nil?
            parenLocation = location.split("(")
            location = parenLocation.first
            phone2 = /((\(\d{3}\))|(\d{3}-))\d{3}-\d{4}/

            location = location.gsub(phone2, '')

          end

          puts bands.gsub(/\s+/, ' ').strip
          puts date.gsub(/\s+/, ' ').strip
          puts location.gsub(/\s+/, ' ').strip

          event = Event.create(
              :bands => bands,
              :time => date,
              :location => location
          )

        end
      end
    end

  def geocodeall
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
end