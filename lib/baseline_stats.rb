require 'httparty'
require 'baseline_endpoints'
require 'active_support/core_ext/hash'


class Baseline
  include BaselineEndpoints

  def self.api_request(endpoint, options = {})
    url_info = ENDPOINTS[endpoint]
    url = url_info[:url].dup
    url_info[:path_params].each do |path_key, value|
      path_value = options[path_key.to_sym] || value[:default]
      url.sub! "{#{path_key}}", path_value.to_s
    end
    query = options.slice(*url_info[:query_params])
    HTTParty.get(url, {:query => query}).with_indifferent_access
  end

  def self.team_player_list(team_id, options = {})
    Baseline.api_request('team_roster', {"teamId": team_id}.merge(options))
  end

  def self.schedule(options = {"sportId" => 1})
    api_response = BaseballApi.api_request('schedule', options)
    games = []
    api_response["dates"].each do |day|
      games += day["games"]
    end
    games
  end

  MLB_LEAGUE_IDS = [103, 104].freeze
  def self.team_list(options = {"leagueIds" => MLB_LEAGUE_IDS})
    Baseline.api_request('teams', options)
  end

  def self.game_at_bats(game_id, options = {})
    api_response = BaseballApi.api_request("game_playByPlay", {"gamePk": game_id}.merge(options))
    api_response['allPlays'].filter{_1["result"]["type"] == "atBat"}
  end

  def self.player_stats(player_id, options = {})
    Baseline.api_request("person_stats", {"personId": player_id, "stats": "season"}.merge(options))
  end

  def self.player_info(player_id, options = {})
    Baseline.api_request("person", {"personId": player_id}.merge(options))["people"].first
  end



  def self.endpoint_info(endpoint)
    ENDPOINTS[endpoint]
  end
end
