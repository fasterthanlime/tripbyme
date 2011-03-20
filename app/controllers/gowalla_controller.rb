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
    
    spots = gowalla.list_spots(:lat => 33.237593417, :lng => -96.960559033, :radius => 50)
    
    #spots.each do |item|
    #  venue = Venue.new(
    #   :name => item["name"],
    #    :lat => item["location"]["lat"].to_f,
    #    :lng => item["location"]["lng"].to_f,
    #    :foursquare_id => item["id"]
    #  )
    #  venue.save
    #end
    
    #@results = JSON.pretty_generate(spots);
    #@results = spots;
    #@results = spots.size;
    @results = spots.map do |spot|
      "Name: #{spot.name}, Category: #{spot.spot_categories.map do |item| item.name end}, Location: (#{spot.lat}, #{spot.lng}, Desc: #{spot.description}\n";
    end
  end

end
