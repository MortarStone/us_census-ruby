# frozen_string_literal: true

module UsCensus
  class ResponseHandler
    attr_accessor :http_response

    def initialize(http_response)
      @http_response = http_response
    end

    def call
      handle_response
    end

    def response
      @response ||= Response.from_http_response(http_response)
    end

    private

    def handle_response
      case response.code
      when 200..299
        response
      when 400
        raise UsCensus::Exceptions::BadRequestError.new(response), response.error_message
      when 401
        raise UsCensus::Exceptions::UnauthorizedError.new(response), response.error_message
      when 403
        raise UsCensus::Exceptions::ForbiddenError.new(response), response.error_message
      when 404
        raise UsCensus::Exceptions::NotFoundError.new(response), response.error_message
      when 500
        raise UsCensus::Exceptions::ResponseError.new(response), response.error_message
      else
        raise UsCensus::Exceptions::UsCStandardError.new(response), response.error_message
      end
    end
  end
end
