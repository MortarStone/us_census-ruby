# frozen_string_literal: true

module UsCensus
  class Response
    include ::ActiveModel::Attributes
    include ::ActiveModel::Model

    attr_accessor :code, :headers, :body, :success, :failure,
                  :status, :reason

    def self.from_http_response(http_response)
      new(
        code: http_response.status,
        # need a hash object rather than Faraday::Utils::Header
        headers: http_response.headers.to_h,
        body: parse_body(http_response.body),
        reason: http_response.reason_phrase,
        success: http_response.success?,
        failure: !http_response.success?,
        status: determine_status(http_response)
      )
    end

    def self.parse_body(response_body)
      return if response_body.empty?

      JSON.parse(response_body)
    rescue JSON::ParserError
      response_body
    end

    def self.determine_status(http_response)
      http_response.success? ? :success : :failure
    end

    def error_message
      "#{code} #{reason}"
    end
  end
end
