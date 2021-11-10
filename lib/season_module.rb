module SeasonEnumerables

  def tackles_in_season(season)
    tackles = Hash.new(0)
    teams_in_season(season).each do |team_id|
      tackles[team_id] = team_tackles(season, team_id)
    end
    tackles
  end

  def win_percentage(results)
    wins = 0
    results.each do |result|
      if result == "WIN"
        wins += 1
      end
    end
    (wins.to_f / results.length).round(2)
  end

  def all_season
    seasons = []
    @games.each do |row|
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
    @games.each do |row|
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
end
