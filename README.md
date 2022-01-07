# UsCensus Ruby API

An API wrapper for UsCensus written in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'us_census'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install us_census

## Obtaining an API Key

You will need a Census Bureau API key. You can request one at https://api.census.gov/data/key_signup.html (https://api.census.gov/data/key_signup.html).

## Usage

### Storing Your API Key

You may want to store your API key as an environment variable.

```ruby
$ export $CENSUS_API_KEY='your-api-key'
```

### Initializing a Client

There are two parameters required: the API key and the API Base URL.

#### Example
```ruby
@client = UsCensus::Client.new(
  api_key: ENV['CENSUS_API_KEY'],
  api_base_url: 'https://api.census.gov/data/2019/acs/acs5'
)
```

#### Why Ask for the API Base URL?
There are a handful of Ruby gems for accessing Census data and they ask the user to specify the dataset (ex. "acs5") and the vintage (ex. "2019"). However, we were unable to use those gems for our purposes because we wanted data later vintages and the gems had not been updated to allow for those vintages.

There are many different datasets and vintages to choose from: https://api.census.gov/data.html (https://api.census.gov/data.html). Not all of the base URLs have the same number of variables, or follow the same patterns.

By asking the user to explicitly provide the API base URL, we elimnate these problems. The Census' API will let the user know if the dataset and vintage is invalid. And presumably, if you are requesting Census data, you know enough about the data you are requesting to provide a valid base URL.

### Requesting Data
The gem formats the parameters accordingly, makes the request and returns a JSON response. The code is intentionally very lean, making it easier to customize your request.

#### Variables

Some of the parameter names used by the Census API are keywords in Ruby so we cannot use the same parameter names.

|Census API parameter name|Gem parameter name|Description|Example|
|---|---|---|---|
|get|variables|an array of variables to retrieve|```[NAME,B19001_001E]```, that represent the name of the group AND "HOUSEHOLD INCOME IN THE PAST 12 MONTHS" in ACS5|
|in|within|a hash of the higher levels of geography|```{ state: 24, county: 005 }``` represents county 005 (Baltimore County) within state 24 (Maryland)|
|for|level|the lowest geography level in the request|```block group:*``` returns the data for all of the block groups within the specified county and state|

#### Example
```ruby
@client.where(
  variables: %w[NAME B19001_001E B19001_002E],
  within: { state: 24, county: '005', tract: 411_407 },
  level: 'block group:4'
)
```
constructs and requests the following URL:
```https://api.census.gov/data/2019/acs/acs5?get=NAME%2CB19001_001E%2CB19001_002E%&in=state%3A24+county%3A005+tract%3A411407&for=block+group%3A4&key=<api_key>```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MortarStone/us_census.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
