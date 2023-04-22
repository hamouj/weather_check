class MapquestService
  def self.get_lat_lng(location)
    get_url("address?location=#{location}")
  end
  
  def self.get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def self.conn
    Faraday.new(url: 'https://www.mapquestapi.com/geocoding/v1/') do |faraday|
      faraday.params['key'] = ENV['mapquest_api_key']
    end
  end
end
