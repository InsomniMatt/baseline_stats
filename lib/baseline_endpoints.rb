require 'active_support/core_ext/hash'
require 'ice_nine'
require 'ice_nine/core_ext/object'

# Required params saved as two dimensional array.  Each inner array is a set of params where 1 of them is required.
# field test_params is an object of parameters for each endpoint which is used when the `test_endpoints` method is called.

module BaselineEndpoints
  BASE_URL = "https://statsapi.mlb.com/api/".freeze
  ENDPOINTS = {
    "attendance": {
      "url": BASE_URL + "{ver}/attendance",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[teamId leagueId season date leagueListId gameType fields],
      "required_params": [%w[teamId leagueId leagueListId]],
      "note": "Requires one of the following paramters to be present: teamId, leagueId, leagueListId.",
      "test_params": {:leagueId => "103"},
    },
    "awards": {
      "url": BASE_URL + "{ver}/awards{awardId}{recipients}",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "awardId": {
          "type": "str",
          "default": nil,
          "leading_slash": true,
        },
        "recipients": {
          "type": "bool",
          "default": false,
          "true": "/recipients",
          "false": "",
        },
      },
      "query_params": %w[sportId leagueId season hydrate fields],
      "required_params": [],
      "note": "Call awards endpoint with no parameters to return a list of awardIds.",
      "test_params": {:season => 2023 }
    },
    "conferences": {
      "url": BASE_URL + "{ver}/conferences",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[conferenceId season fields],
      "required_params": [],
      "test_params": {},
    },
    "divisions": {
      "url": BASE_URL + "{ver}/divisions",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[divisionId leagueId sportId],
      "required_params": [],
      "note": "Call divisions endpoint with no parameters to return a list of divisions.",
      "test_params": {},
    },
    "draft": {
      "url": BASE_URL + "{ver}/draft{prospects}{year}{latest}",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "prospects": {
          "type": "bool",
          "default": false,
          "true": "/prospects",
          "false": "",
        },
        "year": {
          "type": "str",
          "default": Time.now.year.to_s,
          "leading_slash": true,
          "required": true,
        },
        "latest": {
          "type": "bool",
          "default": false,
          "true": "/latest",
          "false": "",
        },
      },
      "query_params": %w[limit fields round name school state country position teamId playerId bisPlayerId],
      "required_params": [],
      "note": 'No query parameters are honored when "latest" endpoint is queried (year is still required). Prospects and Latest cannot be used together.',
      "test_params": {gamePk: 718780},
    },
    "game": {
      "url": BASE_URL + "{ver}/game/{gamePk}/feed/live",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1.1",
          "required": true,
        },
        "gamePk": {
          "type": "str",
          "default": "",
          "required": true,
        },
      },
      "query_params": %w[timecode hydrate fields],
      "required_params": [],
      "test_params": {gamePk: 718780},
    },
    "game_diff": {
      "url": BASE_URL + "{ver}/game/{gamePk}/feed/live/diffPatch",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1.1",
          "required": true,
        },
        "gamePk": {
          "type": "str",
          "default": "",
          "required": true,
        },
      },
      "query_params": %w[startTimecode endTimecode],
      "required_params": [["startTimecode"], ["endTimecode"]],
      "note": "Use the `game_timestamps` endpoint to retrieve all timecodes for a specific game.",
      "test_params": {gamePk: 718780, startTimecode: 20230330_151907, endTimecode: 20230330_201342},
    },
    "game_timestamps": {
      "url": BASE_URL + "{ver}/game/{gamePk}/feed/live/timestamps",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1.1",
          "required": true,
        },
        "gamePk": {
          "type": "str",
          "default": "",
          "required": true,
        },
      },
      "query_params": [],
      "required_params": [],
      "test_params": {gamePk: 718780},
    },
    "game_changes": {
      "url": BASE_URL + "{ver}/game/changes",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[updatedSince sportId gameType season fields],
      "required_params": [],
      "test_params": {},
    },
    "game_context_metrics": {
      "url": BASE_URL + "{ver}/game/{gamePk}/contextMetrics",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "gamePk": {
          "type": "str",
          "default": "",
          "required": true,
        },
      },
      "query_params": %w[timecode fields],
      "required_params": [],
      "test_params": {gamePk: 718780},
    },
    "game_win_probability": {
      "url": BASE_URL + "{ver}/game/{gamePk}/winProbability",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "gamePk": {
          "type": "str",
          "default": "",
          "required": true,
        },
      },
      "query_params": %w[timecode fields],
      "required_params": [],
      "test_params": {gamePk: 718780},
    },
    "game_boxscore": {
      "url": BASE_URL + "{ver}/game/{gamePk}/boxscore",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "gamePk": {
          "type": "str",
          "default": "",
          "required": true,
        },
      },
      "query_params": %w[timecode fields],
      "required_params": [],
      "test_params": {gamePk: 718780},
    },
    "game_content": {
      "url": BASE_URL + "{ver}/game/{gamePk}/content",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "gamePk": {
          "type": "str",
          "default": "",
          "required": true,
        },
      },
      "query_params": %w[highlightLimit],
      "required_params": [],
      "test_params": {gamePk: 718780},
    },
    "game_linescore": {
      "url": BASE_URL + "{ver}/game/{gamePk}/linescore",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "gamePk": {
          "type": "str",
          "default": "",
          "required": true,
        },
      },
      "query_params": %w[timecode fields],
      "required_params": [],
      "test_params": {gamePk: 718780},
    },
    "game_play_by_play": {
      "url": BASE_URL + "{ver}/game/{gamePk}/playByPlay",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "gamePk": {
          "type": "str",
          "default": "",
          "required": true,
        },
      },
      "query_params": %w[timecode fields],
      "required_params": [],
      "test_params": {gamePk: 718780},
    },
    "game_pace": {
      "url": BASE_URL + "{ver}/gamePace",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[season teamIds leagueIds leagueListId sportId gameType startDate endDate venueIds orgType includeChildren fields],
      "required_params": [["season"]],
      "test_params": {season: 2023},
    },
    "high_low": {
      "url": BASE_URL + "{ver}/highLow/{orgType}",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "orgType": {
          "type": "str",
          "default": "",
          "required": true,
        },
      },
      "query_params": %w[statGroup sortStat season gameType teamId leagueId sportIds limit fields],
      "required_params": [["sortStat"], ["season"]],
      "note": "Valid values for orgType parameter: player, team, division, league, sport, types.",
      "test_params": {orgType: "team", sortStat: "hits", season: 2023, teamId: 158 },
    },
    "league": {
      "url": BASE_URL + "{ver}/league",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[sportId leagueIds seasons fields],
      "required_params": [],
      "test_params": {},
    },
    "people": {
      "url": BASE_URL + "{ver}/people",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[personIds hydrate fields],
      "required_params": [["personIds"]],
      "test_params": {personIds: 677594},
    },
    "people_changes": {
      "url": BASE_URL + "{ver}/people/changes",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[updatedSince fields],
      "required_params": [["updatedSince"]],
      "note": "updatedSince param is a DateTime object",
      "test_params": {updatedSince: DateTime.new(2023, 9, 1)},
    },
    "people_free_agents": {
      "url": BASE_URL + "{ver}/people/freeAgents",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "leagueId": {
          "type": "str",
          "default": "",
          "required": true,
        },
      },
      "query_params": %w[order hydrate fields season],
      "required_params": [["season"]],
      "test_params": {leagueId: 103, season: 2023},
    },
    "person": {
      "url": BASE_URL + "{ver}/people/{personId}",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "personId": {
          "type": "str",
          "default": nil,
          "required": true,
        },
      },
      "query_params": %w[hydrate fields],
      "required_params": [],
      "test_params": {personId: 677594},
    },
    "person_stats": {
      "url": BASE_URL + "{ver}/people/{personId}/stats",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "personId": {
          "type": "str",
          "default": nil,
          "required": true,
        },
      },
      "query_params": %w[fields stats],
      "required_params": [["stats"]],
      "note": "Valid values for stats include `season` and `career`",
      "test_params": {personId: 677594, stats: 'season'},
    },
    "person_game_stats": {
      "url": BASE_URL + "{ver}/people/{personId}/stats/game/{gamePk}",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "personId": {
          "type": "str",
          "default": nil,
          "required": true,
        },
        "gamePk": {
          "type": "str",
          "default": "current",
          "required": true,
        },
      },
      "query_params": %[fields],
      "required_params": [],
      "note": "gamePk will default to `current` which will retrieve stats for the current game the player is playing in, if any.",
      "test_params": {personId: 677594, gamePk: 716360},
    },
    "jobs": {
      "url": BASE_URL + "{ver}/jobs",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[jobType sportId date fields],
      "required_params": [["jobType"]],
      "note": "Valid values for jobType are `UMPR`, `MSTR`, `SCOR`",
      "test_params": {jobType: "UMPR"},
    },
    "jobs_umpires": {
      "url": BASE_URL + "{ver}/jobs/umpires",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[sportId date fields],
      "required_params": [],
      "test_params": {},
    },
    "jobs_datacasters": {
      "url": BASE_URL + "{ver}/jobs/datacasters",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[sportId date fields],
      "required_params": [],
      "test_params": {},
    },
    "jobs_official_scorers": {
      "url": BASE_URL + "{ver}/jobs/officialScorers",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[timecode fields],
      "required_params": [],
      "test_params": {},
    },
    "schedule": {
      "url": BASE_URL + "{ver}/schedule",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[scheduleType eventTypes hydrate teamId leagueId sportId gamePk gamePks venueIds gameTypes date startDate endDate opponentId fields],
      "required_params": [%w[sportId gamePk gamePks]],
      "test_params": {sportId: 1, startDate: "2023-03-29", endDate: "2023-10-02"},
    },
    "schedule_tied": {
      "url": BASE_URL + "{ver}/schedule/games/tied",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[gameTypes season hydrate fields],
      "required_params": [["season"]],
      "test_params": {season: 2023},
    },
    "schedule_postseason": {
      "url": BASE_URL + "{ver}/schedule/postseason",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[gameTypes seriesNumber teamId sportId season hydrate fields],
      "required_params": [],
      "test_params": {},
    },
    "schedule_postseason_series": {
      "url": BASE_URL + "{ver}/schedule/postseason/series",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[gameTypes seriesNumber teamId sportId season fields],
      "required_params": [],
      "test_params": {},
    },
    "schedule_postseason_tune_in": {
      "url": BASE_URL + "{ver}/schedule/postseason/tuneIn",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[teamId sportId season hydrate fields],
      "required_params": [],
      "test_params": {},
    },
    "seasons": {
      "url": BASE_URL + "{ver}/seasons{all}",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "all": {
          "type": "bool",
          "default": false,
          "true": "/all",
          "false": "",
          "required": false,
        },
      },
      "query_params": %w[season sportId divisionId leagueId fields],
      "required_params": [%w[sportId divisionId leagueId]],
      "note": "Use the `all` path parameter to retrieve data for all seasons.  The `sportId`, `divisionId`, and `leagueId` params are respected even when the `all` param is used.",
      "test_params": {sportId: 1},
    },
    "season": {
      "url": BASE_URL + "{ver}/seasons/{season}",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "season": {
          "type": "str",
          "default": false,
          "required": true,
        },
      },
      "query_params": %w[sportId fields],
      "required_params": [["sportId"]],
      "test_params": {sportId: 1, season: 2023},
    },
    "sports": {
      "url": BASE_URL + "{ver}/sports",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[sportId fields],
      "required_params": [],
      "test_params": {},
    },
    "sports_players": {
      "url": BASE_URL + "{ver}/sports/{sportId}/players",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "sportId": {
          "type": "str",
          "default": "1",
          "required": true,
        },
      },
      "query_params": %w[season gameType fields],
      "required_params": [["season"]],
      "test_params": {season: 2023},
    },
    "standings": {
      "url": BASE_URL + "{ver}/standings",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[leagueId season standingsTypes date hydrate fields],
      "required_params": [["leagueId"]],
      "test_params": {leagueId: 103},
    },
    "stats": {
      "url": BASE_URL + "{ver}/stats",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[stats playerPool position teamId leagueId limit offset group gameType season sportIds sortStat order hydrate fields personId metrics],
      "required_params": [["stats", "group"]],
      "note": "Limit defaults to 50 records.  `stats` field can be `season` or `career`; `group` can be `hitting`, `pitching`, or `fielding`.",
      "test_params": {stats: "season", group: "hitting"},
    },
    "stats_leaders": {
      "url": BASE_URL + "{ver}/stats/leaders",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[leaderCategories playerPool leaderGameTypes statGroup season leagueId sportId hydrate limit fields statType],
      "required_params": [["leaderCategories"]],
      "note": "If excluding season parameter to get all time leaders, include statType=statsSingleSeason or you will likely not get any results.",
      "test_params": {leaderCategories: "runs", season: 2023, statGroup: "hitting"},
    },
    "teams": {
      "url": BASE_URL + "{ver}/teams",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": [%w[season activeStatus leagueIds sportId sportIds gameType hydrate fields]],
      "required_params": [],
      "test_params": {leagueIds: [103, 104]},
    },
    "teams_history": {
      "url": BASE_URL + "{ver}/teams/history",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[teamIds startSeason endSeason fields],
      "required_params": [%w[teamIds]],
      "test_params": {teamIds: 158},
    },
    "teams_stats": {
      "url": BASE_URL + "{ver}/teams/stats",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[season sportIds group gameType stats order sortStat fields startDate endDate],
      "required_params": [%w[season group stats]],
      "note": "Use meta('statGroups') to look up valid values for group, and meta('statTypes') for valid values for stats.",
      "test_params": {season: 2023, group: "hitting", sortStat: "runs"},
    },
    "teams_affiliates": {
      "url": BASE_URL + "{ver}/teams/affiliates",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[teamIds sportId season hydrate fields],
      "required_params": [["teamIds"]],
      "test_params": {teamIds: 158},
    },
    "team": {
      "url": BASE_URL + "{ver}/teams/{teamId}",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "teamId": {
          "type": "str",
          "default": nil,
          "required": true,
        },
      },
      "query_params": %w[season sportId hydrate fields],
      "required_params": [],
      "test_params": {teamId: 158},
    },
    "team_alumni": {
      "url": BASE_URL + "{ver}/teams/{teamId}/alumni",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "teamId": {
          "type": "str",
          "default": nil,
          "required": true,
        },
      },
      "query_params": %w[season group hydrate fields],
      "required_params": [["season", "group"]],
      "test_params": {teamId: 158, season: 2023},
    },
    "team_coaches": {
      "url": BASE_URL + "{ver}/teams/{teamId}/coaches",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "teamId": {
          "type": "str",
          "default": nil,
          "required": true,
        },
      },
      "query_params": %w[season date fields],
      "required_params": [],
      "test_params": {teamId: 158},
    },
    "team_personnel": {
      "url": BASE_URL + "{ver}/teams/{teamId}/personnel",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "teamId": {
          "type": "str",
          "default": nil,
          "required": true,
        },
      },
      "query_params": %w[date fields],
      "required_params": [],
      "test_params": {teamId: 158},
    },
    "team_leaders": {
      "url": BASE_URL + "{ver}/teams/{teamId}/leaders",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "teamId": {
          "type": "str",
          "default": nil,
          "required": true,
        },
      },
      "query_params": %w[leaderCategories season leaderGameTypes hydrate limit fields],
      "required_params": [%w[leaderCategories season]],
      "test_params": {teamId: 158, season: 2023, leaderCategories: "hits"},
    },
    "team_roster": {
      "url": BASE_URL + "{ver}/teams/{teamId}/roster",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "teamId": {
          "type": "str",
          "default": nil,
          "required": true,
        },
      },
      "query_params": %w[rosterType season date hydrate fields],
      "required_params": [],
      "test_params": {teamId: 158},
    },
    "team_stats": {
      "url": BASE_URL + "{ver}/teams/{teamId}/stats",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "teamId": {
          "type": "str",
          "default": nil,
          "required": true,
        },
      },
      "query_params": %w[season group gameType stats sportIds sitCodes fields],
      "required_params": [%w[group]],
      "note": "Valid endpoint, but have not been able to retrieve anything but an empty object. Use meta('statGroups') to look up valid values for group, and meta('situationCodes') for valid values for sitCodes. Use sitCodes with stats=statSplits.",
      "test_params": {teamId: 158, season: 2023, group: "hitting", stats: "statSplits"},
    },
    "transactions": {
      "url": BASE_URL + "{ver}/transactions",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[teamId playerId date startDate endDate sportId fields],
      "required_params": [%w[teamId playerId date startDate endDate]],
      "test_params": {teamId: 158},
    },
    "venue": {
      "url": BASE_URL + "{ver}/venues",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        }
      },
      "query_params": %w[venueIds season hydrate fields],
      "required_params": [%w[venueIds]],
      "test_params": {venueIds: 32},
    },
    "meta": {
      "url": BASE_URL + "{ver}/{type}",
      "path_params": {
        "ver": {
          "type": "str",
          "default": "v1",
          "required": true,
        },
        "type": {
          "type": "str",
          "default": nil,
          "required": true,
        },
      },
      "query_params": [],
      "required_params": [],
      "note": "Retrieves valid values for various parameters used in other endpoints. Available types: awards, baseballStats, eventTypes, gameStatus, gameTypes, hitTrajectories, jobTypes, languages, leagueLeaderTypes, logicalEvents, metrics, pitchCodes, pitchTypes, platforms, positions, reviewReasons, rosterTypes, scheduleEventTypes, situationCodes, sky, standingsTypes, statGroups, statTypes, windDirection.",
      "test_params": {type: "baseballStats"},
    }
  }.with_indifferent_access.deep_freeze
end