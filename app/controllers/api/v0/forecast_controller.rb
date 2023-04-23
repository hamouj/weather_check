# frozen_string_literal: true

# app/controllers/api/v0/forecast_controller.rb
class Api::V0::ForecastController < ApplicationController
  def index
    if params[:location].present?
      forecast = ForecastFacade.new(params[:location]).fetch_forecast
      location_check(forecast)
    else
      render json: ErrorSerializer.new('A location must be provided').invalid_request, status: 404
    end
  end

  private

  def location_check(forecast)
    if forecast == "Location not found"
      render json: ErrorSerializer.new(forecast).invalid_request, status: 404
    else
      render json: ForecastSerializer.new(forecast).serializable_hash.to_json
    end
  end
end
