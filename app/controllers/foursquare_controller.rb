require 'rubygems'
require 'httpclient'
require 'json'

class FoursquareController < ApplicationController
  def search
    url = "https://api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=HMEWANYJXE0U5UDKIYWYAQLFWVABI4TBGMR3MATVJEFKOHZ0&client_secret=5SQ0UEBC5THYYBDC3OBLGBW4LWPNF0SN3S4TT5JGHJJRNXQX"
    clnt = HTTPClient.new
    jsonObj = JSON.parse(clnt.get_content(url))
    @count = 10
    @items = jsonObj["response"]["groups"][0]["items"]
    #@results = JSON.pretty_generate(jsonObj)
  end
end
