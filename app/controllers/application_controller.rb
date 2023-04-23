class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :error_response

  def error_response(error)
    render json: ErrorSerializer.validation_serialized_json(error), status: 401
  end
end
