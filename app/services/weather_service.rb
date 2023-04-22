# frozen_string_literal: true

# app/services/weather_service.rb
class WeatherService
  def self.get_forecast(lat_lng)
    get_url("v1/forecast.json?q=#{lat_lng}&days=5&hour=0-24")
  end

  def self.get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: 'http://api.weatherapi.com/') do |faraday|
      faraday.params[:key] = ENV['weather_api_key']
    end
  end
end
