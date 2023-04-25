class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :error_response
  rescue_from ActiveRecord::RecordNotFound, with: :bad_credentials_error

  def error_response(error)
    render json: ErrorSerializer.validation_serialized_json(error), status: 401
  end

  def bad_credentials_error
    render json: ErrorSerializer.unauthorized("Invalid credentials"), status: 401
  end
end
