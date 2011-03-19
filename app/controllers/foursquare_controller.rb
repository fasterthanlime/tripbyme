require 'rubygems'
require 'httpclient'
require 'json'

class FoursquareController < ApplicationController
  def search
    if params[:lat] == nil then
      # Lausanne
      @lat = 46.529816
      @lng = 6.630592
    else
      @lat = params[:lat]
      @lng = params[:lng]
    end
    
    client_id     = "HMEWANYJXE0U5UDKIYWYAQLFWVABI4TBGMR3MATVJEFKOHZ0"
    client_secret = "5SQ0UEBC5THYYBDC3OBLGBW4LWPNF0SN3S4TT5JGHJJRNXQX"
    url = "https://api.foursquare.com/v2/venues/search?ll=#{@lat},#{@lng}&client_id=#{client_id}&client_secret=#{client_secret}"
    clnt = HTTPClient.new
    jsonObj = JSON.parse(clnt.get_content(url))
    
    items = jsonObj["response"]["groups"][0]["items"]
    
    items.each do |item|
      venue = Venue.new(
        :name => item["name"],
        :lat => item["location"]["lat"].to_f,
        :lng => item["location"]["lng"].to_f,
        :foursquare_id => item["id"]
      )
      venue.save
    end
  end
end
