require 'rails_helper'

RSpec.describe "Match", type: :model do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user, email: "goggin13@gmail.com")
    tournament = FactoryBot.create(:tournament)
    @home_wrestler = FactoryBot.create(:wrestler)
    @away_wrestler = FactoryBot.create(:wrestler)
    @match = FactoryBot.create(
      :match,
      tournament: tournament,
      home_wrestler: @home_wrestler,
      away_wrestler: @away_wrestler,
      over_under: 10,
    )
  end
end
