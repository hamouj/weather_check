require 'rails_helper'

describe DailyWeather do
  describe 'instance methods' do
    context '#initialize' do
      it 'exists and has attributes' do
        lv_day1_weather = DailyWeather.new(            
          {
            "date": "2023-04-22",
            "day": {
                "maxtemp_f": 84.7,
                "mintemp_f": 59.4,
                "condition": {
                    "text": "Sunny",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png"
                }
            },
            "astro": {
                "sunrise": "05:58 AM",
                "sunset": "07:21 PM",
            }
          })

        expect(lv_day1_weather).to be_a DailyWeather
        expect(lv_day1_weather.date).to eq("2023-04-22")
        expect(lv_day1_weather.sunrise).to eq("05:58 AM")
        expect(lv_day1_weather.sunset).to eq("07:21 PM")
        expect(lv_day1_weather.max_temp).to eq(84.7)
        expect(lv_day1_weather.min_temp).to eq(59.4)
        expect(lv_day1_weather.condition).to eq("Sunny")
        expect(lv_day1_weather.icon).to eq("cdn.weatherapi.com/weather/64x64/day/113.png")
      end
    end
  end
end