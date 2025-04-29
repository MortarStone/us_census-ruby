# frozen_string_literal: true

require_relative 'helper'

response = @client.variables
p response.body
