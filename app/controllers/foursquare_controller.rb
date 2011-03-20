require 'rubygems'
require 'httpclient'
require 'json'

# Foursquare request limits:
#
# 5,000 requests per hour, with more available on request
# by email to api@foursquare.com

class FoursquareController < ApplicationController
  ORIGIN = '4sq'

  def do_venues
    if params[:location] == nil then
      # Lausanne
      @lat, @lng = [46.529816, 6.630592]
    else
      @lat, @lng = params["location"].split(',')
    end
    
    # Hey, it's secret.
    client_id     = "HMEWANYJXE0U5UDKIYWYAQLFWVABI4TBGMR3MATVJEFKOHZ0"
    client_secret = "5SQ0UEBC5THYYBDC3OBLGBW4LWPNF0SN3S4TT5JGHJJRNXQX"
    
    url = "https://api.foursquare.com/v2/venues/search?ll=#{@lat},#{@lng}&client_id=#{client_id}&client_secret=#{client_secret}"
    clnt = HTTPClient.new
    jsonObj = JSON.parse(clnt.get_content(url))
    
    items = jsonObj["response"]["groups"][0]["items"]
    
    items_added = 0
    
    items.each do |item|
      # is origin necessary here?
      id = item["id"]
      next if Venue.where("origin = ? AND foursquare_id = ?", ORIGIN, id).length > 0
    
      venue = Venue.new(
        :origin => "4sq",
        :foursquare_id => id,
        :name => item["name"],
        :description => item["description"],
        :lat => item["location"]["lat"].to_f,
        :lng => item["location"]["lng"].to_f,
        :checkins_count => item["stats"]["checkinsCount"]
      )
      venue.save
      
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
