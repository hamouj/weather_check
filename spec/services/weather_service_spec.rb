require 'rails_helper'

describe WeatherService do
  context 'class methods' do
    context '#get_forecast()' do
      it 'returns the current weather for a location' do
        VCR.use_cassette('weather_forecast_lv', serialize_with: :json) do
          lv_weather = WeatherService.get_forecast('36.17193,-115.14001')

          expect(lv_weather).to be_a Hash

          expect(lv_weather).to have_key :current
          expect(lv_weather[:current]).to have_key :last_updated
          expect(lv_weather[:current][:last_updated]).to be_a String
          expect(lv_weather[:current]).to have_key :temp_f
          expect(lv_weather[:current][:temp_f]).to be_a Float
          expect(lv_weather[:current]).to have_key :feelslike_f
          expect(lv_weather[:current][:feelslike_f]).to be_a Float
          expect(lv_weather[:current]).to have_key :humidity
          expect(lv_weather[:current][:humidity]).to be_an(Integer).or(be_a Float)
          expect(lv_weather[:current]).to have_key :uv
          expect(lv_weather[:current][:uv]).to be_an(Integer).or(be_a Float)
          expect(lv_weather[:current]).to have_key :vis_miles
          expect(lv_weather[:current][:vis_miles]).to be_an(Integer).or(be_a Float)
          expect(lv_weather[:current][:condition]).to have_key :text
          expect(lv_weather[:current][:condition][:text]).to be_a String
          expect(lv_weather[:current][:condition]).to have_key :icon
          expect(lv_weather[:current][:condition][:icon]).to be_a String
        end
      end

      it 'returns the forecast for a location for the next 5 days' do
        VCR.use_cassette('weather_forecast_lv', serialize_with: :json) do
          lv_day1_weather = WeatherService.get_forecast('36.17193,-115.14001')[:forecast][:forecastday][0]

          expect(lv_day1_weather).to be_a Hash

          expect(lv_day1_weather).to have_key :date
          expect(lv_day1_weather[:date]).to be_a String
          expect(lv_day1_weather).to have_key :astro
          expect(lv_day1_weather[:astro]).to have_key :sunrise
          expect(lv_day1_weather[:astro][:sunrise]).to be_a String
          expect(lv_day1_weather[:astro]).to have_key :sunset
          expect(lv_day1_weather[:astro][:sunset]).to be_a String
          expect(lv_day1_weather).to have_key :day
          expect(lv_day1_weather[:day]).to have_key :maxtemp_f
          expect(lv_day1_weather[:day][:maxtemp_f]).to be_a Float
          expect(lv_day1_weather[:day]).to have_key :mintemp_f
          expect(lv_day1_weather[:day][:mintemp_f]).to be_a Float
          expect(lv_day1_weather[:day]).to have_key :condition
          expect(lv_day1_weather[:day][:condition]).to have_key :text
          expect(lv_day1_weather[:day][:condition][:text]).to be_a String
          expect(lv_day1_weather[:day][:condition]).to have_key :icon
          expect(lv_day1_weather[:day][:condition][:icon]).to be_a String
        end
      end
    end

    context '#get_hourly_weather()' do
      it 'returns the hourly weather for a location' do
        VCR.use_cassette('hourly_weather_lv', serialize_with: :json) do
          hourly_lv_weather = WeatherService.get_hourly_weather('36.17193,-115.14001')[:forecast][:forecastday][0]

          expect(hourly_lv_weather).to be_a Hash
          expect(hourly_lv_weather).to have_key :hour
          expect(hourly_lv_weather[:hour]).to be_an Array

          first_hour_weather = hourly_lv_weather[:hour][0]

          expect(first_hour_weather).to have_key :time
          expect(first_hour_weather[:time]).to be_a String
          expect(first_hour_weather).to have_key :temp_f
          expect(first_hour_weather[:temp_f]).to be_a Float
          expect(first_hour_weather).to have_key :condition
          expect(first_hour_weather[:condition]).to have_key :text
          expect(first_hour_weather[:condition][:text]).to be_a String
          expect(first_hour_weather[:condition]).to have_key :icon
          expect(first_hour_weather[:condition][:icon]).to be_a String
        end
      end
    end
  end
end