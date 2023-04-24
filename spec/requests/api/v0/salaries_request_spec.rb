require 'rails_helper'

describe 'Salaries API' do
  describe 'happy path testing' do
    before(:each) do
      VCR.use_cassette('weather_forecast_lv', serialize_with: :json, match_requests_on: [:method, :path]) do
        VCR.use_cassette('lat_lng_lv', serialize_with: :json, match_requests_on: [:method, :path]) do
          VCR.use_cassette('lv_salaries', serialize_with: :json, match_requests_on: [:method, :path]) do
            get "/api/v0/salaries?destination=las-vegas"
          end
        end
      end
    end

    it 'returns salary information about a specific location' do
      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
  
      expect(response_body).to be_a Hash
      expect(response_body).to have_key :data
      expect(response_body[:data].keys).to eq([:id, :type, :attributes])
      expect(response_body[:data][:id]).to eq(nil)
      expect(response_body[:data][:type]).to eq('salaries')
      expect(response_body[:data][:attributes].keys).to eq([:destination, :forecast, :salaries])
      expect(response_body[:data][:attributes][:destination]).to eq('las-vegas')
      expect(response_body[:data][:attributes][:forecast].keys).to eq([:summary, :temperature])
      expect(response_body[:data][:attributes][:forecast][:summary]).to be_a String
      expect(response_body[:data][:attributes][:forecast][:temperature]).to be_an Integer
      expect(response_body[:data][:attributes][:salaries]).to be_an Array
      
      response_body[:data][:attributes][:salaries].each do |salary|
        expect(salary).to have_key :title
        expect(salary[:title]).to be_a String
        expect(salary).to have_key :min
        expect(salary[:min]).to be_a String
        expect(salary).to have_key :max
        expect(salary[:max]).to be_a String
      end
    end
  end
end