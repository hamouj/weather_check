# frozen_string_literal: true

# app/controllers/api/v0/road_trip_controller.rb
class Api::V0::RoadTripController < ApplicationController
  before_action :authenticate_with_key, :check_params

  def create
    road_trip = RoadTripFacade.new(params).complete_road_trip
    if road_trip == "Origin/Destination is not valid"
      render json: ErrorSerializer.invalid_request(road_trip), status: 400
    else
      render json: RoadTripSerializer.new(road_trip)
    end
  end

  private

  def authenticate_with_key
    User.find_by!(api_key: params[:api_key])
  end

  def check_params
    return unless params[:origin].nil? || params[:destination].nil?

    render json: ErrorSerializer.invalid_request("Origin and destination are required"), status: 400
  end
end
