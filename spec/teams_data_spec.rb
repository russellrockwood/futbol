require './lib/stat_tracker'
require './lib/teams_data'

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



  # it 'is exists' do
  #   team_obj = TeamsData.new(@stat_tracker)
  #   expect(team_obj).to be_instance_of(TeamsData)
  # end
  #
  # it 'can store and access teams data' do
  #   team_obj = TeamsData.new(@stat_tracker)
  #
  #   expect(team_obj.teamData).to eq(@stat_tracker.teams)
  # end

  # it 'can return #team_info' do
  #   team_obj = TeamsData.new(@stat_tracker)
  #
  #   expected = {
  #     team_id: 18,
  #     franchiseId: 34,
  #     teamName: "Minnesota United FC",
  #     abbreviation: "MIN",
  #     link: "/api/v1/teams/18"
  #   }
  #   expected(TeamsData.team_info(@team_id)).to eq(expected)
  # end

  # it 'finds all team games' do
  #   team_obj = TeamsData.new(@stat_tracker)
  #   expect(team_obj.all_games_by_team(6).count).to eq(3)
  # end

  xit 'finds best season by team' do
    team_obj = TeamsData.new(@stat_tracker)
    expect(team_obj.best_season(6)).to eq("20122013")
  end

  it 'finds all games between two teams' do
    team_obj = TeamsData.new(@stat_tracker)
    expect(team_obj.get_face_offs(6,3).count).to eq(3)
  end

  it 'calculates face off win percentage' do
    team_obj = TeamsData.new(@stat_tracker)
    face_offs = team_obj.get_face_offs(3,6)

    expect(team_obj.face_off_win_percentage(face_offs, 17).count).to eq(43.48)
  end

  it 'calculates win percentage' do
    team_obj = TeamsData.new(@stat_tracker)
    expect(team_obj.average_win_percentage(6)).to eq(88.89)
  end

  it 'finds most scored goals by team' do
    team_obj = TeamsData.new(@stat_tracker)
    expect(team_obj.most_goals_scored(6)).to eq(4)
  end

  it 'finds lowest scoring game by team' do
    team_obj = TeamsData.new(@stat_tracker)
    expect(team_obj.fewest_goals_scored(6)).to eq(1)
  end

  it 'finds favorite opponent' do
    team_obj = TeamsData.new(@stat_tracker)
    expect(team_obj.favorite_opponent(6)).to eq('Columbus Crew SC')
  end

  it 'finds rival team' do
    team_obj = TeamsData.new(@stat_tracker)
    expect(team_obj.favorite_opponent(6)).to eq('Real Salt Lake')
  end

end
