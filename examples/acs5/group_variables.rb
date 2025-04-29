# frozen_string_literal: true

require_relative 'helper'

response = @client.group_variables('B01001')
p response.body
