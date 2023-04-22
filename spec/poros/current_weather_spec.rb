require 'rails_helper'

describe CurrentWeather do
  describe 'instance methods' do
    context '#initialize' do
      it 'exists and has attributes' do
        lv_current_weather = CurrentWeather.new({
                                                  "last_updated": "2023-04-22 09:45",
                                                  "temp_f": 73.9,
                                                  "condition": {
                                                    "text": "Sunny",
                                                    "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
                                                    "code": 1000
                                                  },
                                                  "humidity": 20,
                                                  "feelslike_f": 73.8,
                                                  "vis_miles": 9.0,
                                                  "uv": 6.0
                                                })

        expect(lv_current_weather).to be_a CurrentWeather
        expect(lv_current_weather.last_updated).to eq("2023-04-22 09:45")
        expect(lv_current_weather.temperature).to eq(73.9)
        expect(lv_current_weather.feels_like).to eq(73.8)
        expect(lv_current_weather.humidity).to eq(20)
        expect(lv_current_weather.uvi).to eq(6.0)
        expect(lv_current_weather.visibility).to eq(9.0)
        expect(lv_current_weather.condition).to eq("Sunny")
        expect(lv_current_weather.icon).to eq("cdn.weatherapi.com/weather/64x64/day/113.png")
      end
    end
  end
end
