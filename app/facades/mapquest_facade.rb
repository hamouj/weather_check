# frozen_string_literal: true

# app/facades/mapquest_facade.rb
class MapquestFacade
  attr_reader :location

  def initialize(location)
    @location = location
  end

  def find_lat_lng
    data = MapquestService.get_lat_lng(@location)[:results][0][:locations][0][:latLng]
    Location.new(data)
  end
end
