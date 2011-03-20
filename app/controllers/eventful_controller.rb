require 'rubygems'
require 'eventful/api'
require 'json'

# Eventful request limits:
#
# The amount of the rate limit is 30,000 API calls per day.
# API calls to add an event, venue, performer or demand have
# no limit and are not included in your daily API call count.
#
# Please contact bizdev@eventful.com for waivers to this rate limit.

class EventfulController < ApplicationController
  ORIGIN = 'evdb'

  def do_venues
    if params[:location] == nil then
      # Lausanne
      @lat, @lng = [46.529816, 6.630592]
    else
      @lat, @lng = params[:location].split(',')
    end
    
    # Our secret API key
    eventful = Eventful::API.new 'w2FxtHT976wb8g4F'
  
    results = eventful.call 'venues/search',
                            :location  => "#{@lat},#{@lng}",
                            :within => 5,
                            :units => "km",
                            :page_size => 30,
                            :date => "future"
                            
    items_added = 0
                            
    # Cache venues into DB :)
    results["venues"]["venue"].each do |item|
      id = item["id"]
      # is origin necessary here?
      next if Venue.where("origin = 'evdb' AND eventful_id = ?", id).length > 0
    
      venue = Venue.new(
        :eventful_id => id,
        :origin => "evdb",
        :name => item["name"],
        :description => item["description"],
        :lat => item["latitude"].to_f,
        :lng => item["longitude"].to_f,
        :checkins_count => -1
      )
      venue.save
      
      items_added = items_added + 1
    end
    
    return "Added #{items_added} items to the DB"
  end

  def venues
    if params[:only_cache] != "1" then
      do_venues
    end
    
    if params[:location] == nil then
      # Lausanne
      @lat, @lng = [46.529816, 6.630592]
    else
      @lat, @lng = params[:location].split(',')
    end
    
    if params[:sw] == nil then
      epsilon = 0.01
      sw_lat, sw_lng = [@lat.to_f - epsilon, @lng.to_f - epsilon]
      ne_lat, ne_lng = [@lat.to_f + epsilon, @lng.to_f + epsilon]
    else
      sw_lat, sw_lng = params[:sw].split(',')
      ne_lat, ne_lng = params[:ne].split(',')
    end
    
    result = []
    
    Venue.where("origin = ? AND lat > ? AND lng > ? AND lat < ? AND lng < ?", ORIGIN, sw_lat, sw_lng, ne_lat, ne_lng).each do |item|
      result.push(item)
    end
    
    render :json => result
  end

end
