# Baseline Stats Library
Ruby wrapper for the MLB Statcast API
Created by Matthew Woodard

## Installation
```
gem install baseline_stats
```

### Requirements
-Ruby 2.7.3+

## Usage

Provides a simple way of contructing requests and calling the Statcast API.
```
require 'baseline_rails'
Baseline.teams.call_api

player_id = 677594     #Julio Rodriguez player id
Baseline.person_stats({personId: player_id, stats: "season"}).call_api

request = Baseline.person
response = request.set_option("personId", player_id).call_api
```

Each available endpoint has a hash in `baseline_endpoints.rb`, containing information about that endpoint.

```
# Example endpoint hash
ENDPOINTS = {...,
    "people": {                                         # Name of the endpoint, callable by Baseline.people
      "url": BASE_URL + "{ver}/people",                 # Url this endpoint will hit
      "path_params": {                                  # Path parameters that will get replaced in the url upon call
        "ver": {                                        # Name of the path parameter
          "type": "str",                                # Type of the path parameter, either str or boolean
          "default": "v1",                              # Default value for this path parameter, will be set to this if not passed in
          "required": true,                             # Whether this parameter is required for this to be a valid request
        }
      },
      "query_params": %w[personIds hydrate fields],     # Query parameters this request could use, only parameters present in the path or query parameter fields will be used to construct the url
      "required_params": [["personIds"]],               # Which, if any, of the query parameters are required; stored as two dimensional array, with each inner array being a set of parameters where at least one is necessary
      "test_params": {personIds: 677594},               # Parameters that will be used in a test call
    },...
}
```

You can test any available endpoint by calling the `test` method on a request object.  This will make an api call with the `test_params` hash set for that endpoint.
```
request = Baseline.game_boxscore
response = request.test
```

An endpoint's info hash can be seen by calling the `info` method
```
Baseline.team_roster.info
```

You can view all available endpoints with the `all_endpoints` method.
```
Baseline.all_endpoints
```

## Copyright notice
This gem and its author are not affiliated with the MLB or any MLB team.
This gem interacts with MLB's Statcast API, whose use is subject to the notice posted at http://gdx.mlb.com/components/copyright.txt.


