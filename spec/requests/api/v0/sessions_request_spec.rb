require 'rails_helper'

describe 'Sessions API' do
  before(:each) do
    user_params = {
      email: 'hailey@gmail.com',
      password: 'ilovemymom',
      password_confirmation: 'ilovemymom'
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v0/users', headers:, params: JSON.generate(user_params)

    @user = User.last
  end

  describe 'happy path testing' do
    it 'authenticates a user and sends the user email and api_key' do
      user_params = {
        email: 'hailey@gmail.com',
        password: 'ilovemymom'
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/sessions', headers:, params: JSON.generate(user_params)

      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a Hash
      expect(response_body).to have_key :data
      expect(response_body[:data].keys).to eq([:id, :type, :attributes])
      expect(response_body[:data][:type]).to eq('users')
      expect(response_body[:data][:id]).to eq(@user.id.to_s)
      expect(response_body[:data][:attributes].keys).to eq([:email, :api_key])
      expect(response_body[:data][:attributes][:email]).to eq(@user.email)
      expect(response_body[:data][:attributes][:api_key]).to eq(@user.api_key)
      expect(response_body[:data][:attributes]).to_not have_key :password
    end
  end

  describe 'sad path testing' do
    it 'returns a status 401 and error message when email or password is missing from the request' do
      user_params = {
        email: 'hailey@gmail.com'
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/sessions', headers:, params: JSON.generate(user_params)

      expect(response.status).to eq(401)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a Hash
      expect(response_body).to have_key(:errors)
      expect(response_body[:errors]).to be_an Array
      expect(response_body[:errors][0].keys).to eq([:status, :title, :detail])
      expect(response_body[:errors][0][:status]).to eq('401')
      expect(response_body[:errors][0][:title]).to eq('Bad Credentials')
      expect(response_body[:errors][0][:detail].first).to eq("Email and password are required")

      user_params = {
        password: 'ilovemymom'
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/sessions', headers:, params: JSON.generate(user_params)

      expect(response.status).to eq(401)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors][0][:detail].first).to eq("Email and password are required")
    end

    it 'returns a status 401 and error message when the email does not exist in the database' do
      user_params = {
        email: 'something@gmail.com',
        password: 'ilovemymom'
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/sessions', headers:, params: JSON.generate(user_params)

      expect(response.status).to eq(401)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors][0][:detail].first).to eq("Invalid email/password")
    end

    it 'returns a status 401 and error message when the email and password do not match the database' do
      user_params = {
        email: 'hailey@gmail.com',
        password: 'ilovemom'
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/sessions', headers:, params: JSON.generate(user_params)

      expect(response.status).to eq(401)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors][0][:detail].first).to eq("Invalid email/password")
    end
  end
end
