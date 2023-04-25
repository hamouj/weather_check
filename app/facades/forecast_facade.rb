# frozen_string_literal: true

# app/facades/weather_facade.rb
class ForecastFacade
  def initialize(location)
    @location = location
  end

  def find_lat_lng
    data = MapquestService.get_lat_lng(@location)
    if data[:results][0][:locations][0][:source] == "FALLBACK"
      return "Error"
    else
      location_data = data[:results][0][:locations][0][:latLng]
      @location_poro ||= Location.new(location_data)
    end
  end

  def fetch_forecast
    if find_lat_lng == "Error"
      "Invalid location"
    else
      data = WeatherService.get_forecast(@location_poro.lat_lng)
      Forecast.new(data)
    end
  end
end
