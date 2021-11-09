require './lib/stat_tracker'
require 'simplecov'
SimpleCov.start
require 'csv'
# SimpleCov.start

RSpec.describe StatTracker do
  before(:each) do
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }
  end

  it 'exists' do

    stat_tracker = StatTracker.from_csv(@locations)

    expect(stat_tracker).to be_an_instance_of(StatTracker)
  end
end
