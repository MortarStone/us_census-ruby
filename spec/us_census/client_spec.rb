# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UsCensus::Client, vcr: true do
  let(:api_base_url) { 'https://api.census.gov/data/2022/acs/acs5' }
  let(:api_key) { ENV.fetch('API_KEY', nil) }

  let(:client) do
    UsCensus::Client.new(
      api_key: api_key,
      api_base_url: api_base_url
    )
  end

  it 'is valid client' do
    expect(client).to be_a(UsCensus::Client)
  end

  it 'api_key is invalid' do
    client = UsCensus::Client.new(api_key: 'asdf', api_base_url: api_base_url)
    expect do
      client.data(variables: %w[Name], within: { state: 24 }, level: 'county=005')
    end.to raise_error(StandardError)
  end

  it 'api_base_url is invalid' do
    client = UsCensus::Client.new(api_key: api_key, api_base_url: 'https://api.census.gov/data/2019/acs/acs')
    expect do
      client.data(variables: %w[Name], within: { state: 24 }, level: 'county=005')
    end.to raise_error(StandardError)
  end

  context 'when parameters' do
    it 'variables are empty' do
      expect do
        client.data(variables: [], within: { state: 24 }, level: 'county=005')
      end.to raise_error(StandardError)
    end

    it 'variables are unknown' do
      expect do
        client.data(variables: %w[alksjdf], within: { state: 24 }, level: 'county=005')
      end.to raise_error(StandardError)
    end

    it "bad formatting of 'for' parameter" do
      expect do
        client.data(
          variables: %w[NAME],
          within: { state: 24, county: '005' },
          level: 'block group=*'
        )
      end.to raise_error(StandardError)
    end

    it 'are valid' do
      results = client.data(
        variables: %w[NAME],
        within: { state: 24, county: '005' },
        level: 'block group:*'
      )
      expect(results.body).to be_an(Array)
    end
  end
end
