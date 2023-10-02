require 'httparty'
require 'baseline_endpoints'
require 'active_support/core_ext/hash'
require 'date'
require 'baseline_request'

class Baseline
  include BaselineEndpoints

  def self.api_request(endpoint, options = {})
    options = options.with_indifferent_access
    error_array = []
    url_info = ENDPOINTS[endpoint]
    url = url_info[:url].dup
    url_info[:path_params].each do |path_key, value|
      case value[:type]
      when "bool"
        path_value = value[options[path_key].to_s] || value[value[:default].to_s]
      else
        path_value = options[path_key] || value[:default]
      end
      error_array << "Missing required path parameter: #{path_key}" if value[:required] && path_value.blank?
      path_value = path_value.to_s
      path_value = "/" + path_value if path_value.present? && value[:leading_slash]
      url.sub! "{#{path_key}}", path_value
    end

    query = options.slice(*url_info[:query_params])
    url_info[:required_params].each do |req_group|
      error_array << "Missing one of the following required parameters: #{req_group.to_s}" unless req_group.any? {query.keys.include? _1 }
    end
    return error_array unless error_array.empty?
    HTTParty.get(url, {:query => query})
  end

  MLB_LEAGUE_IDS = [103, 104].freeze
  def self.team_list(options = {"leagueIds" => MLB_LEAGUE_IDS})
    BaselineRequest.new('teams', options).call_api
  end

  def self.team_player_list(team_id, options = {})
    BaselineRequest.new('team_roster', {"teamId": team_id}.merge(options)).call_api
  end

  def self.all_player_list(season = Time.now.year, options = {})
    BaselineRequest.new("sports_players", {"sportId" => 1, "season" => season}.merge(options)).call_api
  end

  def self.schedule_current_year(start_date = nil, end_date = nil, options = {})
    default_year = DateTime.now.year.to_s
    start_date_string = start_date&.strftime("%Y-%m-%d")
    end_date_string = end_date&.strftime("%Y-%m-%d")
    options["startDate"] = start_date_string || "#{default_year}-03-29"
    options["endDate"] = end_date_string || "#{default_year}-10-02"
    api_response = BaselineRequest.new('schedule', {"sportId" => 1 }.merge(options)).call_api
    games = []
    api_response["dates"].each do |day|
      games += day["games"]
    end
    games
  end

  def self.game_at_bats(game_id, options = {})
    api_response = BaselineRequest.new('game_playByPlay', {"gamePk": game_id}.merge(options)).call_api
    api_response['allPlays'].filter{_1["result"]["type"] == "atBat"}
  end

  def self.player_stats(player_id, options = {})
    BaselineRequest.new('person_stats', {"personId": player_id, "stats": "season"}.merge(options)).call_api
  end

  def self.player_info(player_id, options = {})
    BaselineRequest.new('person', {"personId": player_id}.merge(options))
    Baseline.api_request("person", {"personId": player_id}.merge(options))["people"].first
  end

  def self.endpoint_info(endpoint)
    ENDPOINTS[endpoint]
  end

  def self.test_endpoints
    ENDPOINTS.keys.inject({errors: []}) do |results, key|
      response = BaselineRequest.new(key).test
      code = response.code
      results[:errors] << "#{key}: #{code}" unless code.to_s == "200"
      # Add slight delay to make sure statcast api rate limit isn't hit.
      sleep (0.1)
      results[key] = "#{response.request.uri}: #{response.code}"
      results
    end
  end

  def self.method_missing(m, *args)
    BaselineRequest.new(m, *args)
  end
end
