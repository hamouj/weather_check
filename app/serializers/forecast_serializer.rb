# frozen_string_literal: true

# app/serializers/forecast_serializer.rb
class ForecastSerializer
  include JSONAPI::Serializer
  attributes :current_weather, :daily_weather, :hourly_weather
end
