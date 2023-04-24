# frozen_string_literal: true

# app/services/mapquest_service.rb
class MapquestService
  def self.get_route(origin, destination)
    get_url("directions/v1/route?from=#{origin}&to=#{destination}")
  end
  
  def self.get_lat_lng(location)
    get_url("geocoding/v1/address?location=#{location}")
  end

  def self.get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: 'https://www.mapquestapi.com/') do |faraday|
      faraday.params['key'] = ENV['mapquest_api_key']
    end
  end
end
