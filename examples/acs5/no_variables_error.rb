# frozen_string_literal: true

require_relative 'helper'

response = @client.data(
  variables: %w[],
  within: {
    state: 24,
    county: '005',
    tract: 411_407
  },
  level: 'block group:*'
)

print_response(response)
