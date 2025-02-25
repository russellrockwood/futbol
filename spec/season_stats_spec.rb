require './lib/stat_tracker'
require './lib/league_stats'
require './lib/season_stats'
require './league_stats_module'
require './season_module'
require './games_modules'

require 'simplecov'
SimpleCov.start
require 'csv'

RSpec.describe SeasonStats do
  before :each do
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)
  end

  it 'exists' do
    season_obj = SeasonStats.new(@stat_tracker)
    expect(season_obj).to be_instance_of(SeasonStats)
  end

  it 'creates a hash of data by season' do
    season_obj = SeasonStats.new(@stat_tracker)

    expect(season_obj.hash_games_per_season).to be_a(Hash)
    expect(season_obj.hash_games_per_season.count).to eq(6)
  end

  it 'shows all seasons in dataset' do
    season_obj = SeasonStats.new(@stat_tracker)

    expected = ["20122013", "20162017", "20142015", "20152016", "20132014", "20172018"]
    expect(season_obj.all_season).to eq(expected)
  end

  it 'shows an array of games for a given season' do
    season_obj = SeasonStats.new(@stat_tracker)


    expect(season_obj.array_of_games("20142015")).to be_a Array
  end

  it 'shows an array of coaches for a given season' do
    season_obj = SeasonStats.new(@stat_tracker)
    expected = []

    expect(season_obj.coaches_in_season("20122013").count).to eq(34)
  end

  it 'shows a coaches win percentage' do
    season_obj = SeasonStats.new(@stat_tracker)
    coach = "Mike Yeo"
    season = "20132014"

    expect(season_obj.coach_win_percentage(season, coach)).to eq(0.39)
  end

  it 'shows calculates win percentage' do
    season_obj = SeasonStats.new(@stat_tracker)
    results = ["WIN","WIN","WIN","WIN","LOSS"]

    expect(season_obj.win_percentage(results)).to eq(0.80)
  end

  it 'shows calculates highes win percentage per coach by season' do
    season_obj = SeasonStats.new(@stat_tracker)
    season = "20122013"

    expect(season_obj.winningest_coach(season)).to eq("Claude Julien")
  end

  it 'shows calculates lowest win percentage per coach by season' do
    season_obj = SeasonStats.new(@stat_tracker)
    season = "20122013"

    expect(season_obj.worst_coach(season)).to eq("John Tortorella")
  end

  it 'shows the total tackles for each team_id' do
    season_obj = SeasonStats.new(@stat_tracker)
    season = "20122013"
    team_id = "6"
    expected = 40255


    expect(season_obj.team_tackles(season, team_id)).to eq(expected)
  end

  it 'shows team with most tackles in a season' do
    season_obj = SeasonStats.new(@stat_tracker)
    season = "20122013"
    expected = "Houston Dynamo"

    expect(season_obj.most_tackles(season)).to eq(expected)
  end

  it 'shows team with fewest tackles in a season' do
    season_obj = SeasonStats.new(@stat_tracker)
    season = "20122013"
    expected = "Orlando City SC"

    expect(season_obj.fewest_tackles(season)).to eq(expected)
  end

  it 'shows the ratio of shots to goals for a team' do
    season_obj = SeasonStats.new(@stat_tracker)
    season = "20122013"
    team_id = "6"
    expected = 3.39


    expect(season_obj.team_goals_ratio(season, team_id)).to eq(expected)
  end

  it 'shows team with the best shots to goals ratio in a season' do
    season_obj = SeasonStats.new(@stat_tracker)
    season = "20122013"
    expected = "New York City FC"

    expect(season_obj.most_accurate_team(season)).to eq(expected)
  end

  it 'shows team with the worst shots to goals ratio in a season' do
    season_obj = SeasonStats.new(@stat_tracker)
    season = "20122013"
    expected = "Houston Dynamo"

    expect(season_obj.least_accurate_team(season)).to eq(expected)
  end

end
