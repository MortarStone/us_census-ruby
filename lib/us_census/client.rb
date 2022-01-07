# frozen_string_literal: true

require 'faraday'
require 'json'

module UsCensus
  class Client
    attr_accessor :api_key, :api_base_url

    def initialize(api_key:, api_base_url:)
      @api_key = api_key
      @api_base_url = api_base_url # ex. 'https://api.census.gov/data/2019/acs/acs5'
    end

    # See README for examples and description of parameters. The mapping from the
    # Census API's parameters to the parameters in for request are as follows:
    #   - 'get' => 'variables'
    #   - 'in' => 'within'
    #   - 'for' => 'level'
    def where(variables:, within:, level:)
      params = format_parameters(variables, within, level)
      url = "#{api_base_url}?#{params}"
      # puts url
      response = Faraday.get(url)
      raise error_message(response) unless response.status == 200

      JSON.parse(response.body)
    end

    private

    def format_parameters(variables, within, level)
      URI.encode_www_form(
        get: variables.join(','),
        in: within.map { |k, v| "#{k}:#{v}" }.join(' '),
        for: level,
        key: api_key
      )
    end

    def error_message(response)
      "#{response.reason_phrase} #{response.status}: #{response.body}"
    end
  end
end
