module GamesEnumerables

  def return_percentage(counter, data)
    ((counter.to_f / data.length) * 100).round(2)
  end

  def get_average(counter, data)
    (counter / data.count).round(2)
  end

  def get_team_ids
    team_ids = []
    @game_data.each do |row|
      team_id << row["team_id"]
    end
    team_ids.uniq
  end
end
