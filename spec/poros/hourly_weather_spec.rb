require 'rails_helper'

describe HourlyWeather do
  describe 'instance methods' do
    context '#initialize' do
      it 'exists and has attributes' do
        hour0 = HourlyWeather.new({
          "time": "2023-04-22 00:00",
          "temp_f": 68.9,
          "condition": {
              "text": "Clear",
              "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
          }
        })

        expect(hour0).to be_a HourlyWeather
        expect(hour0.time).to eq("00:00")
        expect(hour0.temperature).to eq(68.9)
        expect(hour0.conditions).to eq("Clear")
        expect(hour0.icon).to eq("cdn.weatherapi.com/weather/64x64/night/113.png")
      end
    end
  end
end