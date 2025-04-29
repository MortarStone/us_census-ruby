# frozen_string_literal: true

module UsCensus
  module Exceptions
    class UsCStandardError < StandardError
      attr_reader :response

      def initialize(response)
        super
        @response = response
      end
    end

    class BadRequestError < UsCStandardError
    end

    class UnauthorizedError < UsCStandardError
    end

    class ForbiddenError < UsCStandardError
    end

    class NotFoundError < UsCStandardError
    end

    class ConnectionError < UsCStandardError
    end

    class ResponseError < UsCStandardError
    end

    class InvalidInputError < UsCStandardError
    end

    class TimeoutError < UsCStandardError
    end
  end
end
