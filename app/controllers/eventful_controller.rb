require 'rubygems'
require 'eventful/api'

# Eventful request limits:
#
# The amount of the rate limit is 30,000 API calls per day.
# API calls to add an event, venue, performer or demand have
# no limit and are not included in your daily API call count.
#
# Please contact bizdev@eventful.com for waivers to this rate limit.

class EventfulController < ApplicationController
  def search
    if params[:lat] == nil then
      # Lausanne
      @lat = 46.529816
      @lng = 6.630592
    else
      @lat = params[:lat]
      @lng = params[:lng]
    end

    # Our secret API key
    eventful = Eventful::API.new 'w2FxtHT976wb8g4F'
  
    results = eventful.call 'venues/search',
                            :location  => "#{@lat},#{@lng}",
                            :within => 20,
                            :units => "km",
                            :page_size => 30,
                            :date => "future"
                            
    # Cache venue into DB :)
    results["venues"]["venue"].each do |item|
      venue = Venue.new(
        :name => item["name"],
        :description => item["description"],
        :lat => item["latitude"].to_f,
        :lng => item["longitude"].to_f,
        :type => "evdb",
        :eventful_id => item["id"]
      )
      venue.save
    end
                            
    @results = JSON.pretty_generate(results)
  end

end
