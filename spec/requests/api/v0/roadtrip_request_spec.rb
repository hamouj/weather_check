require 'rails_helper'

describe 'Roadtrip API' do
  before(:each) do
    # create user
    user_params = {
      email: 'hailey@gmail.com',
      password: 'ilovemymom',
      password_confirmation: 'ilovemymom'
    }
    headers = { "CONTENT_TYPE" => "application/json" }
    post '/api/v0/users', headers:, params: JSON.generate(user_params)
    @api_key = User.last.api_key
  end

  describe 'happy path testing' do
    it 'sends a roadtrip object with attributes when the trip is possible' do
      VCR.use_cassette('lv_to_denver', serialize_with: :json, match_requests_on: [:method, :path]) do
        VCR.use_cassette('lat_lng_denver', serialize_with: :json, match_requests_on: [:method, :path]) do
          roadtrip_params = {
            origin: 'las vegas,nv',
            destination: 'denver,co',
            api_key: @api_key
          }

          headers = { "CONTENT_TYPE" => "application/json" }

          post '/api/v0/roadtrip', headers:, params: JSON.generate(roadtrip_params)

          expect(response).to be_successful

          roadtrip = JSON.parse(response.body, symbolize_names: true)[:data]

          expect(roadtrip.keys).to eq([:id, :type, :attributes])
          expect(roadtrip[:id]).to be(nil)
          expect(roadtrip[:type]).to eq("roadtrip")
          expect(roadtrip[:attributes]).to be_a Hash
          expect(roadtrip[:attributes].keys).to eq([:start_city, :end_city, :travel_time, :weather_at_eta])
          expect(roadtrip[:attributes][:start_city]).to be_a String
          expect(roadtrip[:attributes][:end_city]).to be_a String
          expect(roadtrip[:attributes][:travel_time]).to be_a String
          expect(roadtrip[:attributes][:weather_at_eta]).to be_a Hash
          expect(roadtrip[:attributes][:weather_at_eta].keys).to eq([:datetime, :temperature, :condition])
          expect(roadtrip[:attributes][:weather_at_eta][:datetime]).to be_a String
          expect(roadtrip[:attributes][:weather_at_eta][:temperature]).to be_a Float
          expect(roadtrip[:attributes][:weather_at_eta][:condition]).to be_a String
        end
      end
    end

    it 'sends a roadtrip object with different attributes when the trip is impossible' do
      VCR.use_cassette('ny_to_uk', serialize_with: :json, match_requests_on: [:method, :path]) do
        roadtrip_params = {
          origin: 'new york,ny',
          destination: 'london,uk',
          api_key: @api_key
        }

        headers = { "CONTENT_TYPE" => "application/json" }
          
        post '/api/v0/roadtrip', headers:, params: JSON.generate(roadtrip_params)

        expect(response).to be_successful

        roadtrip = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(roadtrip.keys).to eq([:id, :type, :attributes])
        expect(roadtrip[:id]).to be(nil)
        expect(roadtrip[:type]).to eq("roadtrip")
        expect(roadtrip[:attributes]).to be_a Hash
        expect(roadtrip[:attributes].keys).to eq([:start_city, :end_city, :travel_time, :weather_at_eta])
        expect(roadtrip[:attributes][:start_city]).to be_a String
        expect(roadtrip[:attributes][:end_city]).to be_a String
        expect(roadtrip[:attributes][:travel_time]).to eq("impossible")
        expect(roadtrip[:attributes][:weather_at_eta]).to eq({})
      end
    end
  end

  describe 'sad path testing' do
    it 'returns an error object when the incorrect or no api key is provided' do
      # wrong api key
      roadtrip_params = {
        origin: 'las vegas,nv',
        destination: 'denver,co',
        api_key: '123'
      }

      headers = { "CONTENT_TYPE" => "application/json" }
          
      post '/api/v0/roadtrip', headers:, params: JSON.generate(roadtrip_params)

      expect(response.status).to eq(401)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a Hash
      expect(response_body).to have_key(:errors)
      expect(response_body[:errors]).to be_an Array
      expect(response_body[:errors][0].keys).to eq([:status, :title, :detail])
      expect(response_body[:errors][0][:status]).to eq('401')
      expect(response_body[:errors][0][:title]).to eq('Bad Credentials')
      expect(response_body[:errors][0][:detail].first).to eq("Invalid credentials")

      # no api key
      roadtrip_params = {
        origin: 'las vegas,nv',
        destination: 'denver,co'
      }

      headers = { "CONTENT_TYPE" => "application/json" }
          
      post '/api/v0/roadtrip', headers:, params: JSON.generate(roadtrip_params)

      expect(response.status).to eq(401)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors][0][:detail].first).to eq("Invalid credentials")
    end

    it 'returns an error object when origin, destination or both are missing' do
      # missing destination
      roadtrip_params = {
        origin: 'las vegas,nv',
        api_key: @api_key
      }

      headers = { "CONTENT_TYPE" => "application/json" }
          
      post '/api/v0/roadtrip', headers:, params: JSON.generate(roadtrip_params)

      expect(response.status).to eq(400)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a Hash
      expect(response_body).to have_key(:errors)
      expect(response_body[:errors]).to be_an Array
      expect(response_body[:errors][0].keys).to eq([:status, :title, :detail])
      expect(response_body[:errors][0][:status]).to eq('400')
      expect(response_body[:errors][0][:title]).to eq('Invalid Request')
      expect(response_body[:errors][0][:detail].first).to eq("Origin and destination are required")

      # missing origin
      roadtrip_params = {
        destination: 'denver,co',
        api_key: @api_key
      }

      headers = { "CONTENT_TYPE" => "application/json" }
          
      post '/api/v0/roadtrip', headers:, params: JSON.generate(roadtrip_params)

      expect(response.status).to eq(400)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors][0][:detail].first).to eq("Origin and destination are required")

      # missing destination & origin
      roadtrip_params = {
        api_key: @api_key
      }

      headers = { "CONTENT_TYPE" => "application/json" }
          
      post '/api/v0/roadtrip', headers:, params: JSON.generate(roadtrip_params)

      expect(response.status).to eq(400)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors][0][:detail].first).to eq("Origin and destination are required")
    end
  end
end
