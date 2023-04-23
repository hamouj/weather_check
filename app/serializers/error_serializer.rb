# frozen_string_literal: true

# app/serializers/error_serializer.rb
class ErrorSerializer
  def self.invalid_request(error)
    {
      errors: [
        {
          "status": '404',
          "title": 'Invalid Request',
          "detail": [error]
        }
      ]
    }
  end

  def self.validation_serialized_json(error)
    {
      errors: [
        {
          "status": '401',
          "title": 'Invalid Request',
          "detail": error.message.split(',').map do |message|
            message.strip
          end
        }
      ]
    }
  end

  def self.unauthorized(error)
    {
      errors: [
        {
          "status": '401',
          "title": 'Bad Credentials',
          "detail": [error]
        }
      ]
    }
  end
end
