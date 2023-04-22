require './app/poros/current_weather.rb'
require './app/poros/daily_weather.rb'
require './app/poros/hourly_weather.rb'

class Weather
  attr_reader :current_weather,
              :daily_weather,
              :hourly_weather

  def initialize(data)
    @current_weather = CurrentWeather.new(data[:current])
    @daily_weather = data[:forecast][:forecastday].map { |day_data| DailyWeather.new(day_data) }
    @hourly_weather = data[:forecast][:forecastday][0][:hour].map { |hour_data| HourlyWeather.new(hour_data) }
  end
end