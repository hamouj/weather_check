# frozen_string_literal: true

# app/controllers/api/v0/forecast_controller.rb
class Api::V0::ForecastController < ApplicationController
  def index
    forecast = ForecastFacade.new(params[:location]).fetch_forecast
    render json: ForecastSerializer.new(forecast).serializable_hash.to_json
  end
end
