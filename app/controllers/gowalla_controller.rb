require 'rubygems'
require 'gowalla'

# Gowalla request limits:
#
# Requests using a X-Gowalla-API-Key header can make 5 requests per second.
# Requests that don't provide an API key can make 1 request per second.

class GowallaController < ApplicationController
  def search
    if params[:lat] == nil then
      # Lausanne
      @lat = 46.529816
      @lng = 6.630592
    else
      @lat = params[:lat]
      @lng = params[:lng]
    end
    
    Gowalla.configure do |config|
      # Yay secret API key
      config.api_key = 'd6244e9abe3c4b5394d8666468c2e61d'
      config.username = 'nddrylliog'
      # ooooh. plain text password. I fear :) We're not tumblr, dudes.
      config.password = 'fuckyeahgowalla'
    end
    gowalla = Gowalla::Client.new
    
    spots = gowalla.list_spots(:lat => @lat, :lng => @lng, :radius => 20)
    
    spots.each do |item|
      venue = Venue.new(
        :name => item.name,
        :description => item.description,
        :lat => item.lat,
        :lng => item.lng,
        :foursquare_id => item.foursquare_id,
        :gowalla_id => item.url.split('/').last
        # add description, etc.
      )
      venue.save
    end
    @results = spots
  end

end
