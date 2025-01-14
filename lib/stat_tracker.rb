require_relative './games_data'
require_relative './league_stats'
require_relative './season_stats'
require_relative './teams_data'

require 'csv'

class StatTracker
  include GamesData
  include LeagueStats
  include SeasonStats
  include TeamsData

  attr_reader :data, :games, :teams, :game_teams
  def initialize(data)
    @games = data[:games]
    @teams = data[:teams]
    @game_teams = data[:game_teams]
  end

  def self.convert_path_to_csv(files)
    result = []
    rows = CSV.read(files, headers:true)
    rows.each do |row|
      result << row
    end
    result
  end

  def self.from_csv(locations)
    formatted_data = {}
    locations.each do |symbol, path|
      formatted_data[symbol] = convert_path_to_csv(path)
    end
    StatTracker.new(formatted_data)
  end

end
