# frozen_string_literal: true

# app/controllers/api/v0/forecast_controller.rb
class Api::V0::ForecastController < ApplicationController
  def index
    if params[:location].present?
      forecast = ForecastFacade.new(params[:location]).fetch_forecast
      invalid_location_check(forecast)
    else
      render json: ErrorSerializer.invalid_request('A location must be provided'), status: 400
    end
  end

  private
  
  def invalid_location_check(forecast)
    if forecast == "Invalid location"
      render json: ErrorSerializer.invalid_request(forecast), status: 400
    else
      render json: ForecastSerializer.new(forecast)
    end
  end
end
