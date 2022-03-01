require 'rails_helper'

RSpec.describe "Match", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user, email: "goggin13@gmail.com")
    @tournament = FactoryBot.create(:tournament)
    @home_wrestler = FactoryBot.create(:wrestler)
    @away_wrestler = FactoryBot.create(:wrestler)
    @match = FactoryBot.create(
      :match,
      tournament: @tournament,
      home_wrestler: @home_wrestler,
      away_wrestler: @away_wrestler,
      winner_id: nil,
    )

    FactoryBot.create(:bet, match: @match, wager: "home", user: @user)
    FactoryBot.create(:bet, match: @match, wager: "away", user: @other_user)

    sign_in(@user)
  end

  describe "GET /matches/id.json" do
    it "returns an empty set for payouts if there is no winner" do
      get "/matches/#{@match.id}.json"
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)

      expect(json["payouts"]).to eq({})
    end

    it "returns a set of payouts if there is a winner" do
      @match.update!(winner: @home_wrestler)
      get "/matches/#{@match.id}.json"
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)

      expect(json["payouts"]).to eq(
        @user.id.to_s => Bet::PER_MATCH,
        @other_user.id.to_s => 0
      )
    end
  end
end
