# frozen_string_literal: true

# app/controllers/api/v0/sessions_controller.rb
class Api::V0::SessionsController < ApplicationController
  before_action :params_check

  def create
    user = User.find_by!(email: params[:email])
    if user.authenticate(params[:password])
      render json: UsersSerializer.new(user), status: 200
    else
      render json: ErrorSerializer.unauthorized("Invalid email/password"), status: 401
    end
  end

  private
    def params_check
      if params[:password].nil? || params[:email].nil?
        render json: ErrorSerializer.unauthorized("Email and password are required"), status: 401
      end
    end
end
