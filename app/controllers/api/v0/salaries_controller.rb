# frozen_string_literal: true

# app/controllers/api/v0/salaries_controller.rb
class Api::V0::SalariesController < ApplicationController
  def index
    if params[:destination].present?
      # salaries = ForecastFacade.new(params[:destination]).fetch_forecast
      render json: SalariesSerializer.new(params[:destination]).serialize_salaries
    else
      render json: ErrorSerializer.invalid_request('A location must be provided'), status: 404
    end
  end
end