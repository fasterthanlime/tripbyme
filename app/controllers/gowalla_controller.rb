require 'rubygems'
require 'gowalla'

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
      config.api_key = 'd6244e9abe3c4b5394d8666468c2e61d'
      config.username = 'nddrylliog'
      config.password = 'fuckyeahgowalla' # ooooh. plain text password. I fear :) We're not tumblr, dudes.
    end
    gowalla = Gowalla::Client.new
    
    spots = gowalla.list_spots(:lat => @lat, :lng => @lng, :radius => 50)
    
    spots.each do |item|
      venue = Venue.new(
       :name => item.name,
        :lat => item.lat,
        :lng => item.lng
        # add description, etc.
      )
      venue.save
    end
    
    @results = spots.map do |spot|
      "Name: #{spot.name}, Category: #{spot.spot_categories.map do |item| item.name end}, Location: (#{spot.lat}, #{spot.lng}, Desc: #{spot.description}\n";
    end
  end

end
