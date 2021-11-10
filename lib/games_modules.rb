module GamesEnumerables

  def return_percentage(counter, data)
    ((counter.to_f / data.length)).round(2)
  end

  def get_average(counter, data)
    (counter / data.count).round(2)
  end

  def get_team_ids
    team_ids = []
    @games.each do |row|
      team_id << row["team_id"]
    end
    team_ids.uniq
  end
end
