# frozen_string_literal: true

# app/serializers/road_trip_serializer.rb
class RoadTripSerializer
  include JSONAPI::Serializer
  attributes :start_city, :end_city, :travel_time, :weather_at_eta
end
