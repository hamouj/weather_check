require 'rails_helper'

describe 'Users API' do
  describe 'happy path testing' do
    it 'creates a new user and returns their email and api key' do
      user_params = ({
                      email: 'hailey@gmail.com',
                      password: 'ilovemymom',
                      password_confirmation: 'ilovemymom'
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/users', headers: headers, params: JSON.generate(user_params)
      created_user = User.last

      expect(response.status).to eq(201)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a Hash
      expect(response_body).to have_key :data
      expect(response_body[:data].keys).to eq([:id, :type, :attributes])
      expect(response_body[:data][:type]).to eq('users')
      expect(response_body[:data][:id]).to eq("#{created_user.id}")
      expect(response_body[:data][:attributes].keys).to eq([:email, :api_key])
      expect(response_body[:data][:attributes][:email]).to eq(created_user.email)
      expect(response_body[:data][:attributes][:api_key]).to eq(created_user.api_key)
      expect(response_body[:data][:attributes]).to_not have_key :password
    end
  end

  describe 'sad path testing' do
    it 'returns an error when required information is missing' do
      # missing password and password confirmation
      user_params = ({
        email: 'hailey@gmail.com'
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/users', headers: headers, params: JSON.generate(user_params)

      expect(response.status).to eq(401)
      
      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a Hash
      expect(response_body).to have_key(:errors)
      expect(response_body[:errors]).to be_an Array
      expect(response_body[:errors][0].keys).to eq([:status, :title, :detail])
      expect(response_body[:errors][0][:status]).to eq('401')
      expect(response_body[:errors][0][:title]).to eq('Invalid Request')
      expect(response_body[:errors][0][:detail].first).to eq("Validation failed: Password can't be blank")
      expect(response_body[:errors][0][:detail].second).to eq("Password confirmation can't be blank")

      # missing email
      user_params = ({
        password: 'ilovemymom',
        password_confirmation: 'ilovemymom'
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/users', headers: headers, params: JSON.generate(user_params)

      expect(response.status).to eq(401)
      
      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors][0][:detail].first).to eq("Validation failed: Email can't be blank")

      # missing password_confirmation
      user_params = ({
        email: 'haily@gmail.com',
        password: 'ilovemymom'
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/users', headers: headers, params: JSON.generate(user_params)

      expect(response.status).to eq(401)
      
      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors][0][:detail].first).to eq("Validation failed: Password confirmation can't be blank")

      # missing password
      user_params = ({
        email: 'haily@gmail.com',
        password_confirmation: 'ilovemymom'
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/users', headers: headers, params: JSON.generate(user_params)

      expect(response.status).to eq(401)
      
      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors][0][:detail].first).to eq("Validation failed: Password can't be blank")
    end

    it 'returns an error if the passwords do not match' do
      user_params = ({
        email: 'hailey@gmail.com',
        password: 'abc123',
        password_confirmation: 'ilovemymom'
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/users', headers: headers, params: JSON.generate(user_params)

      expect(response.status).to eq(401)
      
      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a Hash
      expect(response_body).to have_key(:errors)
      expect(response_body[:errors]).to be_an Array
      expect(response_body[:errors][0].keys).to eq([:status, :title, :detail])
      expect(response_body[:errors][0][:status]).to eq('401')
      expect(response_body[:errors][0][:title]).to eq('Invalid Request')
      expect(response_body[:errors][0][:detail].first).to eq("Validation failed: Password confirmation doesn't match Password")
    end

    it 'returns an error if the email is already taken' do
      #create user
      user_params = ({
        email: 'hailey@gmail.com',
        password: 'ilovemymom',
        password_confirmation: 'ilovemymom'
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/users', headers: headers, params: JSON.generate(user_params)

      #send request to create user with same email
      new_user_params = ({
        email: 'hailey@gmail.com',
        password: 'yourock',
        password_confirmation: 'yourock'
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v0/users', headers: headers, params: JSON.generate(new_user_params)

      expect(response.status).to eq(401)
      
      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to be_a Hash
      expect(response_body).to have_key(:errors)
      expect(response_body[:errors]).to be_an Array
      expect(response_body[:errors][0].keys).to eq([:status, :title, :detail])
      expect(response_body[:errors][0][:status]).to eq('401')
      expect(response_body[:errors][0][:title]).to eq('Invalid Request')
      expect(response_body[:errors][0][:detail].first).to eq("Validation failed: Email has already been taken")
    end
  end
end