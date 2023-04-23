# frozen_string_literal: true

# app/controllers/api/v0/users_controller.rb
class Api::V0::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    user.save!
    render json: UsersSerializer.new(user), status: 201
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation)
    end
end