require 'rails_helper'

RSpec.describe "Match", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @admin_user = FactoryBot.create(:user, email: "goggin13@gmail.com")
    @tournament = FactoryBot.create(:tournament)
    @home_wrestler = FactoryBot.create(:wrestler)
    @away_wrestler = FactoryBot.create(:wrestler)
    @match = FactoryBot.create(
      :match,
      closed: true,
      tournament: @tournament,
      home_wrestler: @home_wrestler,
      away_wrestler: @away_wrestler,
    )
  end

  describe "PUT /matches/id.json" do
    before do
      sign_in(@admin_user)
    end

    it "sets home_score, away_score, and spread" do
      put "/matches/#{@match.id}.json", params: {
        match: {
          home_score: 1,
          away_score: 2,
          spread: 3,
        }
      }
      expect(response.status).to eq(200)

      @match.reload
      expect(@match.home_score).to eq(1)
      expect(@match.away_score).to eq(2)
      expect(@match.spread).to eq(3)
    end
  end
end
