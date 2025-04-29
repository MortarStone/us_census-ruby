# frozen_string_literal: true

require_relative 'helper'

response = @client.groups
p response.body
