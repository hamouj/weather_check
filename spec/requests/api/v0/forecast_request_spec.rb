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

      expect(daily_weather.count).to eq(5)

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

      expect(hourly_weather.count).to eq(24)

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

    it 'only sends required information based on the json contract' do
      response_body = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response_body[:attributes]).to_not have_key :location
      expect(response_body[:attributes][:current_weather]).to_not have_key :wind_mph
      expect(response_body[:attributes][:current_weather]).to_not have_key :id
      expect(response_body[:attributes][:current_weather]).to_not have_key :type
      expect(response_body[:attributes][:current_weather]).to_not have_key :attributes
      expect(response_body[:attributes][:daily_weather][0]).to_not have_key :avghumidity
      expect(response_body[:attributes][:daily_weather][0]).to_not have_key :id
      expect(response_body[:attributes][:daily_weather][0]).to_not have_key :type
      expect(response_body[:attributes][:daily_weather][0]).to_not have_key :attributes
      expect(response_body[:attributes][:hourly_weather][0]).to_not have_key :feels_like
      expect(response_body[:attributes][:hourly_weather][0]).to_not have_key :id
      expect(response_body[:attributes][:hourly_weather][0]).to_not have_key :type
      expect(response_body[:attributes][:hourly_weather][0]).to_not have_key :attributes
    end
  end

  describe 'sad path/edge case testing' do
    it 'returns an error object when location query parameters are not included' do
      get "/api/v0/forecast"

      expect(response.status).to eq(400)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a Hash
      expect(response_body).to have_key(:errors)
      expect(response_body[:errors]).to be_an Array
      expect(response_body[:errors][0].keys).to eq([:status, :title, :detail])
      expect(response_body[:errors][0][:status]).to eq('400')
      expect(response_body[:errors][0][:title]).to eq('Invalid Request')
      expect(response_body[:errors][0][:detail].first).to eq('A location must be provided')
    end

    it 'returns an error object when location query parameters are left blank' do
      get "/api/v0/forecast?location="

      expect(response.status).to eq(400)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to have_key(:errors)
      expect(response_body[:errors][0][:status]).to eq('400')
      expect(response_body[:errors][0][:title]).to eq('Invalid Request')
      expect(response_body[:errors][0][:detail].first).to eq('A location must be provided')
    end
    
    it 'returns a fallback location when the location entered does not exist' do
      VCR.use_cassette('incorrect_location', serialize_with: :json) do
        get "/api/v0/forecast?location=akjsdf,mnp"

        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).to have_key :data
        expect(response_body[:data].keys).to eq([:id, :type, :attributes])
      end
    end
  end
end
