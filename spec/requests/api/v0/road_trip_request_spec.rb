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
      VCR.use_cassette('lv_to_denver', serialize_with: :json, match_requests_on: [:method, :path], allow_playback_repeats: true) do
        VCR.use_cassette('lat_lng_denver', serialize_with: :json, match_requests_on: [:method, :path], allow_playback_repeats: true) do
          road_trip_params = {
            origin: 'las vegas,nv',
            destination: 'denver,co',
            api_key: @api_key
          }

          headers = { "CONTENT_TYPE" => "application/json" }

          post '/api/v0/road_trip', headers:, params: JSON.generate(road_trip_params)

          expect(response).to be_successful

          road_trip = JSON.parse(response.body, symbolize_names: true)[:data]

          expect(road_trip.keys).to eq([:id, :type, :attributes])
          expect(road_trip[:id]).to be(nil)
          expect(road_trip[:type]).to eq("road_trip")
          expect(road_trip[:attributes]).to be_a Hash
          expect(road_trip[:attributes].keys).to eq([:start_city, :end_city, :travel_time, :weather_at_eta])
          expect(road_trip[:attributes][:start_city]).to be_a String
          expect(road_trip[:attributes][:start_city]).to eq(road_trip_params[:origin])
          expect(road_trip[:attributes][:end_city]).to be_a String
          expect(road_trip[:attributes][:end_city]).to eq(road_trip_params[:destination])
          expect(road_trip[:attributes][:travel_time]).to be_a String
          expect(road_trip[:attributes][:weather_at_eta]).to be_a Hash
          expect(road_trip[:attributes][:weather_at_eta].keys).to eq([:datetime, :temperature, :condition])
          expect(road_trip[:attributes][:weather_at_eta][:datetime]).to be_a String
          expect(road_trip[:attributes][:weather_at_eta][:temperature]).to be_a Float
          expect(road_trip[:attributes][:weather_at_eta][:condition]).to be_a String
        end
      end
    end

    it 'sends a roadtrip object with different attributes when the trip is impossible' do
      VCR.use_cassette('ny_to_uk', serialize_with: :json, match_requests_on: [:method, :path]) do
        road_trip_params = {
          origin: 'new york,ny',
          destination: 'london,uk',
          api_key: @api_key
        }

        headers = { "CONTENT_TYPE" => "application/json" }

        post '/api/v0/road_trip', headers:, params: JSON.generate(road_trip_params)

        expect(response).to be_successful

        road_trip = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(road_trip.keys).to eq([:id, :type, :attributes])
        expect(road_trip[:id]).to be(nil)
        expect(road_trip[:type]).to eq("road_trip")
        expect(road_trip[:attributes]).to be_a Hash
        expect(road_trip[:attributes].keys).to eq([:start_city, :end_city, :travel_time, :weather_at_eta])
        expect(road_trip[:attributes][:start_city]).to be_a String
        expect(road_trip[:attributes][:start_city]).to eq(road_trip_params[:origin])
        expect(road_trip[:attributes][:end_city]).to be_a String
        expect(road_trip[:attributes][:end_city]).to eq(road_trip_params[:destination])
        expect(road_trip[:attributes][:travel_time]).to eq("impossible")
        expect(road_trip[:attributes][:weather_at_eta]).to eq({})
      end
    end

    it 'only sends required information based on the json contract' do
      VCR.use_cassette('lv_to_denver', serialize_with: :json, match_requests_on: [:method, :path], allow_playback_repeats: true) do
        VCR.use_cassette('lat_lng_denver', serialize_with: :json, match_requests_on: [:method, :path], allow_playback_repeats: true) do
          road_trip_params = {
            origin: 'las vegas,nv',
            destination: 'denver,co',
            api_key: @api_key
          }

          headers = { "CONTENT_TYPE" => "application/json" }

          post '/api/v0/road_trip', headers:, params: JSON.generate(road_trip_params)

          response_body = JSON.parse(response.body, symbolize_names: true)[:data]

          expect(response_body[:attributes][:weather_at_eta]).to_not have_key :id
          expect(response_body[:attributes]).to_not have_key :type
        end
      end
    end
  end

  describe 'sad path/edge case testing' do
    it 'returns an error object when the incorrect or no api key is provided' do
      # wrong api key
      road_trip_params = {
        origin: 'las vegas,nv',
        destination: 'denver,co',
        api_key: '123'
      }

      headers = { "CONTENT_TYPE" => "application/json" }

      post '/api/v0/road_trip', headers:, params: JSON.generate(road_trip_params)

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
      road_trip_params = {
        origin: 'las vegas,nv',
        destination: 'denver,co'
      }

      headers = { "CONTENT_TYPE" => "application/json" }

      post '/api/v0/road_trip', headers:, params: JSON.generate(road_trip_params)

      expect(response.status).to eq(401)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors][0][:detail].first).to eq("Invalid credentials")
    end

    it 'returns an error object when origin, destination or both are missing' do
      # missing destination
      road_trip_params = {
        origin: 'las vegas,nv',
        api_key: @api_key
      }

      headers = { "CONTENT_TYPE" => "application/json" }

      post '/api/v0/road_trip', headers:, params: JSON.generate(road_trip_params)

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
      road_trip_params = {
        destination: 'denver,co',
        api_key: @api_key
      }

      headers = { "CONTENT_TYPE" => "application/json" }

      post '/api/v0/road_trip', headers:, params: JSON.generate(road_trip_params)

      expect(response.status).to eq(400)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors][0][:detail].first).to eq("Origin and destination are required")

      # missing destination & origin
      road_trip_params = {
        api_key: @api_key
      }

      headers = { "CONTENT_TYPE" => "application/json" }

      post '/api/v0/road_trip', headers:, params: JSON.generate(road_trip_params)

      expect(response.status).to eq(400)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors][0][:detail].first).to eq("Origin and destination are required")
    end

    it 'returns an error when the origin or destination are not real places' do
      # destination invalid
      VCR.use_cassette('incorrect_roadtrip_destination', serialize_with: :json) do
        road_trip_params = {
          origin: 'las vegas,nv',
          destination: 'dkjsdj',
          api_key: @api_key
        }

        headers = { "CONTENT_TYPE" => "application/json" }

        post '/api/v0/road_trip', headers:, params: JSON.generate(road_trip_params)

        expect(response.status).to eq(400)

        response_body = JSON.parse(response.body, symbolize_names: true)
  
        expect(response_body).to be_a Hash
        expect(response_body).to have_key(:errors)
        expect(response_body[:errors]).to be_an Array
        expect(response_body[:errors][0].keys).to eq([:status, :title, :detail])
        expect(response_body[:errors][0][:status]).to eq('400')
        expect(response_body[:errors][0][:title]).to eq('Invalid Request')
        expect(response_body[:errors][0][:detail].first).to eq("Origin/Destination is not valid")
      end

      VCR.use_cassette('incorrect_roadtrip_origin', serialize_with: :json) do
        road_trip_params = {
          origin: 'lkjd',
          destination: 'denver,co',
          api_key: @api_key
        }

        headers = { "CONTENT_TYPE" => "application/json" }

        post '/api/v0/road_trip', headers:, params: JSON.generate(road_trip_params)

        expect(response.status).to eq(400)

        response_body = JSON.parse(response.body, symbolize_names: true)
  
        expect(response_body).to be_a Hash
        expect(response_body).to have_key(:errors)
        expect(response_body[:errors]).to be_an Array
        expect(response_body[:errors][0].keys).to eq([:status, :title, :detail])
        expect(response_body[:errors][0][:status]).to eq('400')
        expect(response_body[:errors][0][:title]).to eq('Invalid Request')
        expect(response_body[:errors][0][:detail].first).to eq("Origin/Destination is not valid")
      end
    end
  end
end
