require 'rubygems'
require 'httpclient'
require 'json'

# Foursquare request limits:
#
# 5,000 requests per hour, with more available on request
# by email to api@foursquare.com

Your application should try to play nicely against our methods. For instance, cache results on your side wherever possible (e.g., /venue calls usually tend to be more long-lived than others). Send back an identifiable User-Agent header.

We're still learning about your apps and tweaking these caps. If your application runs into any of our bounds and you think you could use more, write us: api@foursquare.com. Depending on the method you are using to access our API, we'll need one of the following:
Basic authentication: your user name
OAuth: the email address you used to register with foursquare _and_ your OAuth consumer key
Anonymous: Ask for v2 access

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
    
    # Hey, it's secret.
    client_id     = "HMEWANYJXE0U5UDKIYWYAQLFWVABI4TBGMR3MATVJEFKOHZ0"
    client_secret = "5SQ0UEBC5THYYBDC3OBLGBW4LWPNF0SN3S4TT5JGHJJRNXQX"
    
    url = "https://api.foursquare.com/v2/venues/search?ll=#{@lat},#{@lng}&client_id=#{client_id}&client_secret=#{client_secret}"
    clnt = HTTPClient.new
    jsonObj = JSON.parse(clnt.get_content(url))
    
    items = jsonObj["response"]["groups"][0]["items"]
    
    items.each do |item|
      venue = Venue.new(
        :name => item["name"],
        :description => item["description"],
        :lat => item["location"]["lat"].to_f,
        :lng => item["location"]["lng"].to_f,
        :type => "4sq",
        :foursquare_id => item["id"]
      )
      venue.save
    end
    
    @results = "Added #{items.length} items to the DB"
  end
end
