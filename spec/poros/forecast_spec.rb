require 'rails_helper'

describe Forecast do
  describe 'instance methods' do
    context '#initialize' do
      it 'creates CurrentWeather, DailyWeather, and HourlyWeather objects' do
        VCR.use_cassette('weather_forecast_lv', serialize_with: :json, match_requests_on: [:method, :path]) do
          lv_weather_data = WeatherService.get_forecast('lasvegas,nv')

          lv_weather = Forecast.new(lv_weather_data)

          expect(lv_weather).to be_a Forecast
          expect(lv_weather.id).to be nil
          expect(lv_weather.current_weather).to be_a CurrentWeather
          expect(lv_weather.daily_weather.first).to be_a DailyWeather
          expect(lv_weather.daily_weather.count).to eq(5)
          expect(lv_weather.hourly_weather.first).to be_a HourlyWeather
          expect(lv_weather.hourly_weather.count).to eq(24)
        end
      end
    end
  end
end