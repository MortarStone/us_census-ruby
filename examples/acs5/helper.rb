# frozen_string_literal: true

require 'pry'
require 'active_support/inflector'
require_relative '../../lib/us_census'

require 'dotenv'
Dotenv.load('../../.env')

@client = UsCensus::Client.new(
  api_key: ENV['API_KEY'],
  api_base_url: 'https://api.census.gov/data/2019/acs/acs5'
)

def print_response(results)
  if results.empty?
    puts 'None'
  else
    results.each { |row| p row }
  end
  puts
end
