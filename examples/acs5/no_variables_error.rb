# frozen_string_literal: true

require_relative 'helper'

results = @client.where(
  variables: %w[],
  within: {
    state: 24,
    county: '005',
    tract: 411_407
  },
  level: 'block group:*'
)

print_response(results)
