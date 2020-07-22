require 'rails_helper'

RSpec.describe "Bet", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    home_wrestler = FactoryBot.create(:wrestler)
    away_wrestler = FactoryBot.create(:wrestler)
    @match = FactoryBot.create(
      :match,
      tournament: @tournament,
      home_wrestler: home_wrestler,
      away_wrestler: away_wrestler,
      winner_id: nil,
    )
    sign_in(@user)
  end

  describe "POST /bets" do
    it "creates a bet" do
      expect do
        post "/bets.json", params: {bet: {match_id: @match.id, wager: "home"}}
        expect(response.status).to eq(201)
      end.to change(Bet, :count).by(1)

      bet = Bet.last!
      expect(bet.user_id).to eq(@user.id)
      expect(bet.match_id).to eq(@match.id)
      expect(bet.wager).to eq("home")
    end

    it "fails if the match is closed" do
      @match.update!(:closed => true)
      expect do
        post "/bets.json", params: {bet: {match_id: @match.id, wager: "home"}}
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)["match"][0]).to eq("Must be open for betting")
      end.to change(Bet, :count).by(0)
    end

    it "fails if the match has a winner" do
      @match.update!(:winner_id => 1)
      expect do
        post "/bets.json", params: {bet: {match_id: @match.id, wager: "home"}}
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)["match"][0]).to eq("Match already has a winner")
      end.to change(Bet, :count).by(0)
    end

    it "replaces the current bet if there is one" do
      FactoryBot.create(:bet, user_id: @user.id, match: @match, wager: "away")
      expect do
        post "/bets.json", params: {bet: {match_id: @match.id, wager: "home"}}
        expect(response.status).to eq(201)
      end.to change(Bet, :count).by(0)

      bet = Bet.last!
      expect(bet.user_id).to eq(@user.id)
      expect(bet.match_id).to eq(@match.id)
      expect(bet.wager).to eq("home")
    end

    it "accepts a second bet by the same user" do
      other_match = FactoryBot.create(:match, tournament: @tournament, winner_id: nil)
      FactoryBot.create(:bet, user_id: @user.id, match: other_match)

      expect do
        post "/bets.json", params: {bet: {match_id: @match.id, wager: "home"}}
        expect(response.status).to eq(201)
      end.to change(Bet, :count).by(1)

      bet = Bet.last!
      expect(bet.user_id).to eq(@user.id)
      expect(bet.match_id).to eq(@match.id)
      expect(bet.wager).to eq("home")
    end
  end
end
