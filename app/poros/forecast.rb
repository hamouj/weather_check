# frozen_string_literal: true

require './app/poros/current_weather'
require './app/poros/daily_weather'
require './app/poros/hourly_weather'

# app/poros/forecast.rb
class Forecast
  attr_reader :id,
              :current_weather,
              :daily_weather,
              :hourly_weather

  def initialize(data)
    @id = nil
    @current_weather = CurrentWeather.new(data[:current])
    @daily_weather = data[:forecast][:forecastday].map { |day_data| DailyWeather.new(day_data) }
    @hourly_weather = data[:forecast][:forecastday][0][:hour].map { |hour_data| HourlyWeather.new(hour_data) }
  end
end
