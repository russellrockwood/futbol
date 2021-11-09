require './lib/stat_tracker'
require './lib/teams_data'
require 'simplecov'
SimpleCov.start

RSpec.describe TeamsData do
  before(:each) do

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

  it 'is exists' do
    team_obj = TeamsData.new(@stat_tracker)

    expect(team_obj).to be_instance_of(TeamsData)
  end

  it 'can store and access teams data' do
    team_obj = TeamsData.new(@stat_tracker)

    expect(team_obj.team_data).to eq(@stat_tracker.teams)
  end

  it 'can return #team_info' do
    team_obj = TeamsData.new(@stat_tracker)

    expected = {
      team_id: 18,
      franchiseId: 34,
      teamName: "Minnesota United FC",
      abbreviation: "MIN",
      link: "/api/v1/teams/18"
    }
    expect(team_obj.team_info(18)).to eq(expected)
  end

  it 'finds all team games' do
    team_obj = TeamsData.new(@stat_tracker)

    expect(team_obj.all_games_by_team(6)).to be_a(Array)
    expect(team_obj.all_games_by_team(6).count).to eq(510)
  end

  it 'finds all game_teams by team id' do
    team_obj = TeamsData.new(@stat_tracker)
    team_id = 6

    expect(team_obj.team_games_by_id(team_id)).to be_a(Array)
    expect(team_obj.team_games_by_id(team_id).count).to eq(510)
  end

  it 'calculates win percentage' do
    team_obj = TeamsData.new(@stat_tracker)
    team_id = 6
    season = '20132014'
    games = team_obj.team_games_per_season(team_id)

    expect(team_obj.season_win_percentage(games[season], team_id)).to eq(57.45)
  end

  it 'creates win percentages by season hash' do
    team_obj = TeamsData.new(@stat_tracker)
    team_id = 6

    expect(team_obj.win_percentages_by_season(team_id)).to be_a(Hash)
    expect(team_obj.win_percentages_by_season(team_id).count).to eq(6)
  end

  it 'gets team games per season' do
    team_obj = TeamsData.new(@stat_tracker)
    team_id = 6
    games = team_obj.team_games_per_season(team_id)
    season = '20132014'

    expect(games).to be_a(Hash)
    expect(games[season].length).to eq(94)
  end

  it 'finds best season by team' do
    team_obj = TeamsData.new(@stat_tracker)
    team_id = 6

    expect(team_obj.best_season(team_id)).to eq("20132014")
  end

  it 'finds worst season by team' do
    team_obj = TeamsData.new(@stat_tracker)
    team_id = 6

    expect(team_obj.worst_season(team_id)).to eq("20142015")
  end

  it 'finds all games between two teams' do
    team_obj = TeamsData.new(@stat_tracker)
    team1_id = 6
    team2_id = 3
    team3_id = 17

    expect(team_obj.get_face_offs(team1_id, team2_id).count).to eq(23)
    expect(team_obj.get_face_offs(team1_id, team3_id).count).to eq(26)
  end

  it 'calculates face off win percentage' do
    team_obj = TeamsData.new(@stat_tracker)
    face_offs = team_obj.get_face_offs(3,6)
    team_id = 6

    expect(team_obj.face_off_win_percentage(face_offs, team_id)).to eq(52.17)
  end

  it 'calculates average win percentage for all games by team' do
    team_obj = TeamsData.new(@stat_tracker)
    team_id = 6

    expect(team_obj.average_win_percentage(team_id)).to eq(62.59)
  end

  it 'finds most scored goals by team' do
    team_obj = TeamsData.new(@stat_tracker)
    team_id = 6

    expect(team_obj.most_goals_scored(team_id)).to eq(6)
  end

  it 'finds lowest scoring game by team' do
    team_obj = TeamsData.new(@stat_tracker)
    team_id = 6

    expect(team_obj.fewest_goals_scored(team_id)).to eq(0)
  end

  it 'creates opponent win percentage hash' do
    team_obj = TeamsData.new(@stat_tracker)
    team_id = 6

    expect(team_obj.opponent_win_percentages(team_id)).to be_a(Hash)
    expect(team_obj.opponent_win_percentages(team_id).count).to eq(31)
  end

  it 'finds favorite opponent' do
    team_obj = TeamsData.new(@stat_tracker)
    team_id = 6

    expect(team_obj.favorite_opponent(team_id)).to eq('Columbus Crew SC')
  end

  it 'finds rival team' do
    team_obj = TeamsData.new(@stat_tracker)
    team_id = 6

    expect(team_obj.rival(team_id)).to eq('Real Salt Lake')
  end

end
