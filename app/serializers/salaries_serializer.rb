# frozen_string_literal: true

# app/serializers/salaries_serializer.rb
class SalariesSerializer
  def initialize(destination)
    @destination = destination
    @forecast = ForecastFacade.new(@destination).fetch_forecast
    @salaries = SalaryFacade.new(@destination).fetch_salaries
  end

  def serialize_salaries
    {
      "data": {
        "id": nil,
        "type": "salaries",
        "attributes": {
          "destination": @destination,
          "forecast": {
            "summary": @forecast.current_weather.condition,
            "temperature": @forecast.current_weather.temperature.round()
          },
          "salaries":
            @salaries.each do |salary|
              {
              "title": salary.title,
              "min": salary.min,
              "max": salary.max
              }
            end
        }
      }
    }
  end
end
