# frozen_string_literal: true

require_relative 'helper'

# B19001_001E
# B19001_002E
# B19001_003E
# B19001_004E
# B19001_005E
# B19001_006E
# B19001_007E
# B19001_008E
# B19001_009E
# B19001_010E
# B19001_011E
# B19001_012E
# B19001_013E
# B19001_014E
# B19001_015E
# B19001_016E
# B19001_017E

response = @client.data(
  variables: %w[
    NAME
  ],
  within: {
    state: 24,
    county: '005',
    tract: 411_407
  },
  level: 'block group:4'
)

print_response(response)
