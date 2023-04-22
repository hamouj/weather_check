# frozen_string_literal: true

# app/facades/weather_facade.rb
class ForecastFacade
  def initialize(location)
    @location = location
  end

  def find_lat_lng
    data = MapquestService.get_lat_lng(@location)[:results][0][:locations][0][:latLng]
    @_lat_lng ||= Location.new(data)
  end

  def fetch_forecast
    data = WeatherService.get_forecast(@lat_lng)
    Forecast.new(data)
  end
end