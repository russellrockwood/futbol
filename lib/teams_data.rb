require './lib/stat_tracker'
require './lib/games_modules'
require './lib/league_stats_module'

class TeamsData

  include GamesEnumerables
  include LeagueEnumerables

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

  def all_games_by_team(team_id)
    games = @game_data.select do |row|
      row['home_team_id'] == team_id.to_s || row['away_team_id'] == team_id.to_s
    end
    games
  end

  def season_win_percentage(season_games, team_id)
    total_won = 0

    season_games.each do |game|
      home_win = game['home_goals'] > game['away_goals']
      away_win = game['away_goals'] > game['home_goals']

      if team_id.to_s == game['home_team_id'] && home_win
        total_won += 1

      elsif team_id.to_s == game['away_team_id'] &&    away_win
        total_won += 1
      end
    end
     return_percentage(total_won, season_games)
  end

  def team_games_per_season(team_id)
    team_games = all_games_by_team(team_id)

    seasons = @game_data.map do |row|
      row['season']
    end.uniq

    season_games = Hash[seasons.collect { |item| [item, team_games.select { |game| item == game['season']}] } ]

    season_games
  end

  def win_percentages_by_season(team_id)
    team_games = team_games_per_season(team_id)

    win_percentages_by_season = {}
    team_games.each do |season, games|
      win_percentages_by_season[season] = season_win_percentage(games, team_id)
    end
    win_percentages_by_season
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

  def team_games_by_id(team_id)
    selected_team_games = @game_teams_data.select do |csv_row|
      csv_row["team_id"] == team_id.to_s
    end
    selected_team_games
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

  def get_opponent_ids(team_games, team_id)
    opponent_ids = []
    team_games.each do |row|
      if row['home_team_id'] == team_id.to_s
        opponent_ids << row['away_team_id']
      end
      if row['away_team_id'] == team_id.to_s
        opponent_ids << row['home_team_id']
      end
    end
    opponent_ids = opponent_ids.uniq
  end

  def get_face_offs(team1_id, team2_id)
    team1_games = all_games_by_team(team1_id)

    face_offs = team1_games.select do |row|
      row['home_team_id'] == team2_id.to_s || row['away_team_id'] == team2_id.to_s
    end

    face_offs
  end

  def face_off_win_percentage(face_offs, team_id)
    # game_ids = []
    # face_offs.each do |game|
    #   game_ids << game['game_id']
    # end
    #
    # results = []
    # @game_teams_data.each do |game|
    #   if game_ids.any? {|id| id == game['game_id']}
    #     results << game
    #   end
    # end
    #
    # total_won = 0
    # total_lost = 0
    # results.each do |game|
    #   if team_id.to_s == game['team_id'] && game['result'] == 'WIN'
    #     total_won += 1
    #   elsif team_id.to_s != game['team_id'] && game['result'] == 'LOSS'
    #     total_won += 1
    #   else
    #     total_lost += 1
    #   end
    season_win_percentage(face_offs, team_id)
    # end

    # win_percentage = ((total_won / (total_won + total_lost).to_f) * 100).round(2)
    # win_percentage
  end

  def opponent_win_percentages(team_id)
    team_games = all_games_by_team(team_id)
    opponent_ids = get_opponent_ids(team_games, team_id)

    games_by_team = Hash.new
    opponent_ids.each do |opponent_id|
      games_by_team[opponent_id] = get_face_offs(team_id, opponent_id.to_i)
    end

    win_percentage_by_team = Hash.new
    games_by_team.each do |opponent_id, all_face_offs|
      win_percentage_by_team[opponent_id] = face_off_win_percentage(all_face_offs, team_id)
    end
    win_percentage_by_team
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
