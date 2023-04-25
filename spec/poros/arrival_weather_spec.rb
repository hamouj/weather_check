require 'rails_helper'

describe ArrivalWeather do
  describe 'instance methods' do
    context '#initialize' do
      it 'exists and has attributes' do
        denver_weather_data = {
          "forecast": {
            "forecastday": [
              "hour": [
                {
                  "time_epoch": 1682326800,
                  "time": "2023-04-24 02:00",
                  "temp_c": 19.4,
                  "temp_f": 66.9,
                  "is_day": 0,
                  "condition": {
                    "text": "Clear",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                    "code": 1000
                  }
                }
              ]
            ]
          }
        }

        denver_weather = ArrivalWeather.new(denver_weather_data[:forecast][:forecastday][0][:hour][0])

        expect(denver_weather).to be_an ArrivalWeather
        expect(denver_weather.datetime).to eq('2023-04-24 02:00')
        expect(denver_weather.temperature).to eq(66.9)
        expect(denver_weather.condition).to eq('Clear')
      end
    end
  end
end
