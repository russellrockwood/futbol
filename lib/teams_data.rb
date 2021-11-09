require './lib/stat_tracker'
require './lib/games_modules'
require './lib/league_stats_module'
require './lib/teams_module'

class TeamsData

  include GamesEnumerables
  include LeagueEnumerables
  include TeamsEnumerables

  attr_reader :team_data

  def initialize(current_stat_tracker)
    @team_data = current_stat_tracker.teams
    @game_data = current_stat_tracker.games
    @game_teams_data = current_stat_tracker.game_teams
  end

  def team_info(team_id)
    selected_team = @team_data.select do |csv_row|
        csv_row["team_id"] == team_id.to_s
      end

      team_hash = {
        team_id: selected_team[0]["team_id"].to_i,
        franchiseId: selected_team[0]["franchiseId"].to_i,
        teamName: selected_team[0]["teamName"],
        abbreviation: selected_team[0]["abbreviation"],
        link: selected_team[0]["link"]
      }
      team_hash
  end

  def best_season(team_id)
    find_max(win_percentages_by_season(team_id))
  end

  def worst_season(team_id)
    find_min(win_percentages_by_season(team_id))
  end

  def average_win_percentage(team_id)
    selected_team_games = @game_teams_data.select do |csv_row|
      csv_row["team_id"] == team_id.to_s
    end

    total_won = []
    total_lost = []
    selected_team_games.each do |game|
      if game["result"] == "WIN"
        total_won << game
      elsif game["result"] == "LOSS"
        total_lost << game
      end
    end
    average_win_percentage = ((total_won.size / (total_won.size + total_lost.size).to_f) * 100).round(2)

    average_win_percentage
  end

  def most_goals_scored(team_id)
    selected_team_games = team_games_by_id(team_id)
    highest_score = 0
    selected_team_games.each do |game|
      if game["goals"].to_i > highest_score
        highest_score = game["goals"].to_i
      end
    end
    highest_score
  end

  def fewest_goals_scored(team_id)
    selected_team_games = team_games_by_id(team_id)
    lowest_score = 100
    selected_team_games.each do |game|
      if game["goals"].to_i < lowest_score
        lowest_score = game["goals"].to_i
      end
    end
    lowest_score
  end

  def favorite_opponent(team_id)
    favorite_opponent_id = find_max(opponent_win_percentages(team_id))
    convert_team_id_to_name(favorite_opponent_id.to_i)
  end

  def rival(team_id)
    rival_id = find_min(opponent_win_percentages(team_id))
    convert_team_id_to_name(rival_id.to_i)
  end
end
