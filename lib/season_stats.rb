require './lib/season_module'

class SeasonStats
  # include SeasonEnumerable

  attr_reader :game_data,
              :team_data,
              :game_teams,
              :season_data

  def initialize(current_stat_tracker)
    @game_data = current_stat_tracker.games
    @team_data = current_stat_tracker.teams
    @game_teams = current_stat_tracker.game_teams
    # @season_data = season_game_ids_to_games
  end

  def all_season
    seasons = []
    # This each can be refactors

    @game_data.each do |row|
      seasons << row['season']
    end
    seasons.uniq
  end

  def game_ids_to_games(game_ids)
    results = []
    @game_teams.each do |game|
      if game_ids.any? {|id| id == game['game_id']}
        results << game
      end
    end

    results
  end

  def array_of_games(season)
    games_array = []
    @game_data.each do |row|
      if row["season"] == season
        games_array << row["game_id"]
      end
    end
    games_array
  end

  def season_game_ids_to_games
    new_hash = {}
    season_hash = hash_games_per_season
    season_hash.each do |season, game_ids|
      new_hash[season] =  game_ids_to_games(game_ids)
    end
    new_hash
  end

  def hash_games_per_season
    games_per_season = Hash.new
    all_season.each do |season|
      games_per_season[season] = array_of_games(season)
    end
    games_per_season
  end

  def coaches_in_season(season)
    data = season_game_ids_to_games
    coaches = []
    data[season].each do |row|
      coaches << row['head_coach']
    end
    coaches.uniq
  end

  def coach_win_percentage(season, coach)
    result_array = []
    @game_teams.each do |row|
      if array_of_games(season).include?(row['game_id']) && row["head_coach"] == coach
          result_array << row["result"]
      end
    end
    win_percentage(result_array)
  end

  def winningest_coach(season)
    hash = Hash.new
    coaches = coaches_in_season(season)
    coaches.each do |coach|
      hash[coach] = coach_win_percentage(season, coach)
    end
    hash.key(hash.values.max)
  end

  def worst_coach(season)
    hash = Hash.new
    coaches = coaches_in_season(season)
    coaches.each do |coach|
      hash[coach] = coach_win_percentage(season, coach)
    end
    hash.key(hash.values.min)
  end

  def win_percentage(results)
    wins = 0
    tie = 0
    loss = 0
    results.each do |result|
      if result == "WIN"
        wins += 1
      elsif result == "TIE"
        tie += 1
      else result == "LOSS"
        loss += 1
      end
    end
    (wins.to_f / results.length).round(2)
  end

  def teams_in_season(season)
    team_ids = []
    @game_teams.each do |row|
      if array_of_games(season).include?(row['game_id'])
        team_ids << row["team_id"]
      end
    end
    team_ids.uniq
  end

  def team_tackles(season, team_id)
    result_array = []
    @game_teams.each do |row|
      if array_of_games(season).include?(row['game_id']) && row["team_id"] == team_id
          result_array << row["tackles"].to_i
      end
    end
    result_array.sum
  end

  def most_tackles(season)
    tackles = Hash.new
    teams_id = teams_in_season(season)
    teams_id.each do |team_id|
      tackles[team_id] = team_tackles(season, team_id)
    end
    convert_team_id_to_name(tackles.key(tackles.values.max).to_i)
  end

## Needs to be put into a module
  def convert_team_id_to_name(team_id_integer)
    name_array = []
    @team_data.each do |row|
      if row['team_id'].to_i == team_id_integer
        name_array << row['teamName']
      end
    end
    name_array[0]
  end

  def fewest_tackles(season)
    tackles = Hash.new
    teams_id = teams_in_season(season)
    teams_id.each do |team_id|
      tackles[team_id] = team_tackles(season, team_id)
    end
    convert_team_id_to_name(tackles.key(tackles.values.min).to_i)
  end

  def team_goals_ratio(season, team_id)
    shots_array = []
    goals_array = []
    @game_teams.each do |row|
      if array_of_games(season).include?(row['game_id']) && row["team_id"] == team_id
          shots_array<< row["shots"].to_i
      end
    end
    @game_teams.each do |row|
      if array_of_games(season).include?(row['game_id']) && row["team_id"] == team_id
          goals_array << row["goals"].to_i
      end
    end
    (shots_array.sum / goals_array.sum.to_f).round(2)
  end

  def most_accurate_team(season)
    ratio = Hash.new
    teams_id = teams_in_season(season)
    teams_id.each do |team_id|
      ratio[team_id] = team_goals_ratio(season, team_id)
    end
    convert_team_id_to_name(ratio.key(ratio.values.min).to_i)
  end

  def least_accurate_team(season)
    ratio = Hash.new
    teams_id = teams_in_season(season)
    teams_id.each do |team_id|
      ratio[team_id] = team_goals_ratio(season, team_id)
    end
    convert_team_id_to_name(ratio.key(ratio.values.max).to_i)
  end
end
