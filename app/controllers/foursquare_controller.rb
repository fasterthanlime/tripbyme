require 'rubygems'
require 'httpclient'
require 'json'

class FoursquareController < ApplicationController
  def search
    ## brooklyn
    #@lat = 40.7
    #@lng = -74
    
    # lausanne
    @lat = 46.529816
    @lng = 6.630592
    
    client_id     = "HMEWANYJXE0U5UDKIYWYAQLFWVABI4TBGMR3MATVJEFKOHZ0"
    client_secret = "5SQ0UEBC5THYYBDC3OBLGBW4LWPNF0SN3S4TT5JGHJJRNXQX"
    url = "https://api.foursquare.com/v2/venues/search?ll=#{@lat},#{@lng}&client_id=#{client_id}&client_secret=#{client_secret}"
    clnt = HTTPClient.new
    jsonObj = JSON.parse(clnt.get_content(url))
    @count = 10
    @items = jsonObj["response"]["groups"][0]["items"]
    #@results = JSON.pretty_generate(jsonObj)
  end
end