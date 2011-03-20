require 'rubygems'
require 'eventful/api'

class EventfulController < ApplicationController
  def search
    if params[:lat] == nil then
      # Lausanne
      @lat = 46.529816
      @lng = 6.630592
    else
      @lat = params[:lat]
      @lng = params[:lng]
    end
    
    eventful = Eventful::API.new 'w2FxtHT976wb8g4F'
  
    results = eventful.call 'venues/search',
                            :location  => "#{@lat},#{@lng}",
                            :within => 50,
                            :units => "km",
                            :page_size => 30,
                            :date => "future"
                            
    # Cache venue into DB :)
    results["venues"]["venue"].each do |item|
      venue = Venue.new(
        :name => item["name"],
        :lat => item["latitude"].to_f,
        :lng => item["longitude"].to_f,
        :eventful_id => item["id"]
      )
      venue.save
    end
                            
    @results = JSON.pretty_generate(results)
  end

end
