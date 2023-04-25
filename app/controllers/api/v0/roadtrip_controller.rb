# frozen_string_literal: true

# app/controllers/api/v0/roadtrip_controller.rb
class Api::V0::RoadtripController < ApplicationController
  before_action :authenticate_with_key, :check_params

  def index
    roadtrip = RoadtripFacade.new(params).complete_roadtrip
    render json: RoadtripSerializer.new(roadtrip)
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
