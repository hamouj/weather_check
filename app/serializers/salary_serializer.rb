# frozen_string_literal: true

# app/serializers/salary_serializer.rb
class SalarySerializer
  def initialize(destination)
    @destination = destination
    @forecast = ForecastFacade.new(@destination).fetch_forecast
    @salaries = SalaryFacade.new(@destination).fetch_salaries
  end

  def self.send_salaries
    {
      "data": {
        "id": null,
        "type": "salaries",
        "attributes": {
          "destination": @destination,
          "forecast": {
            "summary": @forecast.current_weather.condition,
            "temperature": @forecast.current_weather.temperature
          },
          "salaries": [
            @salaries.each do |salary|
              "title": salary.title,
              "min": salary.min,
              "max": salary.max
            end
          ]
        }
      }
    }
  end
end
