# baseline_stats
Ruby gem to interact with the StatCast Baseball API

Endpoints, unless otherwise specified, options defaults to empty hash.
```
Baseline.team_list #Retrieves all MLB teams
Baseline.team_player_list(team_id, options) # Retrieves roster list for a specific team
Baseline.all_player_list(season, options) # Retrieves a list of all MLB players for a specific season, season defaults to current year
Baseline.schedule(start_date, end_date, options) # Retrieves list of games between start_date and end_date, these fields default to start and end of season for current year, dates should be given as DateTime objects
Baseline.game_at_bats(game_id, options) # Retrieves list of At Bats for the given game id
Baseline.player_stats(player_id, options) # Retrieves stats for the given player id
Baseline.player_info(player_id, options) # Retrieves info for the given player id
Baseline.api_request(endpoint, options) # Manually call a statcast api endpoint, as defined in `baseline_endpoints.rb`
```
