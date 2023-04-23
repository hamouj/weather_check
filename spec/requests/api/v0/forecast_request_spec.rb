require 'rails_helper'

describe 'Forecast API' do
  describe 'happy path testing' do
    before(:each) do
      VCR.use_cassette('weather_forecast_lv', serialize_with: :json, match_requests_on: [:method, :path]) do
        VCR.use_cassette('lat_lng_lv', serialize_with: :json, match_requests_on: [:method, :path]) do  
          get "/api/v0/forecast?location=lasvegas,nv"
        end
      end
    end

    it 'sends a forecast object with attributes' do
      expect(response).to be_successful

      forecast = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(forecast.keys).to eq([:id, :type, :attributes])
      expect(forecast[:id]).to be(nil)
      expect(forecast[:type]).to eq("forecast")
      expect(forecast[:attributes]).to be_a Hash
      expect(forecast[:attributes].keys).to eq([:current_weather, :daily_weather, :hourly_weather])
      expect(forecast[:attributes][:current_weather]).to be_a Hash
      expect(forecast[:attributes][:daily_weather]).to be_an Array
    end

    it 'sends a forecast object with a current weather key with current weather attributes' do
      current_weather = JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:current_weather]

      expect(current_weather).to have_key :last_updated
      expect(current_weather[:last_updated]).to be_a String
      expect(current_weather).to have_key :temperature
      expect(current_weather[:temperature]).to be_a Float
      expect(current_weather).to have_key :feels_like
      expect(current_weather[:feels_like]).to be_a Float
      expect(current_weather).to have_key :humidity
      expect(current_weather[:humidity]).to be_a(Float).or be_an(Integer)
      expect(current_weather).to have_key :uvi
      expect(current_weather[:uvi]).to be_a(Float).or be_an(Integer)
      expect(current_weather).to have_key :visibility
      expect(current_weather[:visibility]).to be_a(Float).or be_an(Integer)
      expect(current_weather).to have_key :condition
      expect(current_weather[:condition]).to be_a String
      expect(current_weather).to have_key :icon
      expect(current_weather[:icon]).to be_a String
    end

    it 'sends a forecast object with a daily weather key with daily weather attributes' do
      daily_weather = JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:daily_weather]

      daily_weather.each do |day|
        expect(day).to have_key :date
        expect(day[:date]).to be_a String
        expect(day).to have_key :sunrise
        expect(day[:sunrise]).to be_a String
        expect(day).to have_key :sunset
        expect(day[:sunset]).to be_a String
        expect(day).to have_key :max_temp
        expect(day[:max_temp]).to be_a Float
        expect(day).to have_key :min_temp
        expect(day[:min_temp]).to be_a Float
        expect(day).to have_key :condition
        expect(day[:condition]).to be_a String
        expect(day).to have_key :icon
        expect(day[:icon]).to be_a String
      end
    end

    it 'sends a forecast object with a hourly weather key with hourly weather attributes' do
      hourly_weather = JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:hourly_weather]

      hourly_weather.each do |hour|
        expect(hour).to have_key :time
        expect(hour[:time]).to be_a String
        expect(hour).to have_key :temperature
        expect(hour[:temperature]).to be_a Float
        expect(hour).to have_key :conditions
        expect(hour[:conditions]).to be_a String
        expect(hour).to have_key :icon
        expect(hour[:icon]).to be_a String
      end
    end
  end
end