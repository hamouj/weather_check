# frozen_string_literal: true

# app/serializers/user_serializer.rb
class UsersSerializer
  include JSONAPI::Serializer
  attributes :email, :api_key
end