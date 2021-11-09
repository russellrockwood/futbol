module TeamsEnumerables

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

  def team_games_by_id(team_id)
    selected_team_games = @game_teams_data.select do |csv_row|
      csv_row["team_id"] == team_id.to_s
    end
    selected_team_games
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
    season_win_percentage(face_offs, team_id)
  end

end
