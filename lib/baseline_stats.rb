require 'httparty'
require 'baseline_endpoints'
require 'active_support/core_ext/hash'
require 'date'
require 'baseline_request'

class Baseline
  include BaselineEndpoints


  MLB_LEAGUE_IDS = [103, 104].freeze
  def self.team_list(options = {"leagueIds" => MLB_LEAGUE_IDS})
    BaselineRequest.new('teams', options).call_api
  end

  def self.team_player_list(options = {})
    BaselineRequest.new('team_roster', options).call_api
  end

  def self.all_player_list(options = {})
    BaselineRequest.new("sports_players", options)
                   .set_option("sportId", 1, false)
                   .set_option("season", Time.now.year, false).call_api
  end

  def self.schedule_year(year, options = {})
    request = BaselineRequest.new('schedule', options)
                             .set_option("sportId", 1, false)
                             .set_option("startDate", "#{year}-03-29")
                             .set_option("endDate", "#{year}-10-02")
    request.call_api["dates"].inject([]) do |result, day|
      result += day["games"]
      result
    end
  end

  def self.game_at_bats(game_id, options = {})
    api_response = BaselineRequest.new('game_playByPlay', options).set_option("gamePk", game_id).call_api
    api_response['allPlays'].filter{_1["result"]["type"] == "atBat"}
  end

  def self.player_stats(player_id, options = {})
    BaselineRequest.new('person_stats', options)
                   .set_option("personId", player_id)
                   .set_option("stats", "season", false).call_api
  end

  def self.player_info(player_id, options = {})
    BaselineRequest.new('person', options).set_option("personId", player_id).call_api
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
