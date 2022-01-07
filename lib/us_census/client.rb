# frozen_string_literal: true

require 'faraday'
require 'json'

module UsCensus
  class Client
    attr_accessor :api_key, :api_base_url

    # We could attempt to construct the URL, but there are too many variations
    # that do not follow a pattern, or require too many inputs. For a list,
    # see https://api.census.gov/data.html.
    def initialize(api_key:, api_base_url:)
      @api_key = api_key # request one at https://api.census.gov/data/key_signup.html
      @api_base_url = api_base_url # ex. 'https://api.census.gov/data/2019/acs/acs5'
    end

    # Some of the parameter names used by the Census API are keywords in Ruby so
    # we cannot use the same parameter names.
    # 'variables'
    #   Census API name: 'get'
    #   Description:     an array of variables to retrieve
    #   Example:         'B19001_001E', that represents "HOUSEHOLD INCOME IN THE
    #                    PAST 12 MONTHS" in ACS5
    # 'within'
    #   Census API name: 'in'
    #   Description:     a hash of the higher levels of geography
    #   Example:         { state: 24, county: 005 } represents county 005
    #                    (Baltimore County) within state 24 (Maryland)
    # 'level'
    #   Census API name: 'for'
    #   Description:     the lowest geography level in the request
    #   Example:         'block group:*' returns the data for all of the block groups
    #                    within the specified county and state
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
