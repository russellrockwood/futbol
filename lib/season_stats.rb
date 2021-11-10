require_relative './stat_tracker'
require_relative './league_stats_module'
require_relative './season_module'
require_relative './games_modules'

module SeasonStats
  include GamesEnumerables
  include LeagueEnumerables
  include SeasonEnumerables

  def coaches_in_season(season)
    data = season_game_ids_to_games
    coaches = []
    data[season].each do |row|
      coaches << row['head_coach']
    end
    coaches.uniq
  end

  def coach_win_percentage(season, coach)
    data = season_game_ids_to_games
    results_array = []
    data[season].each do |row|
      if row['head_coach'] == coach
        results_array << row['result']
      end
    end
    win_percentage(results_array)
  end

  def winningest_coach(season)
    hash = Hash.new
    coaches = coaches_in_season(season)
    coaches.each do |coach|
      hash[coach] = coach_win_percentage(season, coach)
    end
    find_max(hash)
  end

  def worst_coach(season)
    hash = Hash.new
    coaches = coaches_in_season(season)
    coaches.each do |coach|
      hash[coach] = coach_win_percentage(season, coach)
    end
    find_min(hash)
  end

  def team_tackles(season, team_id)
    data = season_game_ids_to_games
    result_array = []
    data[season].each do |row|
      result_array << row["tackles"].to_i
    end
    result_array.sum
  end

  def most_tackles(season)
    tackles = Hash.new
    get_team_ids.each do |team_id|
      tackles[team_id] = team_tackles(season, team_id)
    end
    convert_team_id_to_name(find_max(tackles).to_i)
  end

  def fewest_tackles(season)
    tackles = Hash.new
    get_team_ids.each do |team_id|
      tackles[team_id] = team_tackles(season, team_id)
    end
    convert_team_id_to_name(find_min(tackles).to_i)
  end

  def team_goals_ratio(season, team_id)
    data = season_game_ids_to_games
    shots_array = []
    goals_array = []
    data[season].each do |row|
        shots_array << row["shots"].to_i
    end
    data[season].each do |row|
      goals_array << row["goals"].to_i
    end
    (shots_array.sum / goals_array.sum.to_f).round(2)
  end

  def most_accurate_team(season)
    ratio = Hash.new
    get_team_ids.each do |team_id|
      ratio[team_id] = team_goals_ratio(season, team_id)
    end
    convert_team_id_to_name(find_min(ratio).to_i)
  end

  def least_accurate_team(season)
    ratio = Hash.new
    get_team_ids.each do |team_id|
      ratio[team_id] = team_goals_ratio(season, team_id)
    end
    convert_team_id_to_name(find_max(ratio).to_i)
  end
end
