require 'rubygems'
require 'gowalla'

# Gowalla request limits:
#
# Requests using a X-Gowalla-API-Key header can make 5 requests per second.
# Requests that don't provide an API key can make 1 request per second.

class GowallaController < ApplicationController
  ORIGIN = 'gowalla'

  def do_venues
    if params[:location] == nil then
      # Lausanne
      @lat, @lng = [46.529816, 6.630592]
    else
      @lat, @lng = params["location"].split(',')
    end
    
    Gowalla.configure do |config|
      # Yay secret API key
      config.api_key = 'd6244e9abe3c4b5394d8666468c2e61d'
      config.username = 'nddrylliog'
      # ooooh. plain text password. I fear :) We're not tumblr, dudes.
      config.password = 'fuckyeahgowalla'
    end
    gowalla = Gowalla::Client.new
    
    spots = gowalla.list_spots(:lat => @lat, :lng => @lng, :radius => 5)
    
    items_added = 0
    
    spots.each do |item|
      id = item.url.split('/').last
      # is origin necessary here?
      next if Venue.where("origin = ? AND gowalla_id = ?", ORIGIN, id).length > 0
      next if Venue.where("foursquare_id = ?", id).length > 0
      
      venue = Venue.new(
        :origin => "gowalla",
        :gowalla_id => id,
        :name => item.name,
        :description => item.description,
        :lat => item.lat,
        :lng => item.lng,
        :foursquare_id => item.foursquare_id,
        :checkins_count => item.checkins_count
      )
      #venue.save
      
      items_added = items_added + 1
    end
    
    @results = "Added #{items_added} items to the DB"
  end
  
  def venues
    if params[:only_cache] != "1" then
      do_venues
    end
    
    result = []
    
    Venue.where("origin = ?", ORIGIN).each do |item|
      result.push(item)
    end
    
    render :json => result
  end

end
