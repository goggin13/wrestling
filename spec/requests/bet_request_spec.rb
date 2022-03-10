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
    )
    sign_in(@user)
  end

  describe "POST /bets" do
    before do
      @params = { bet: {
          match_id: @match.id,
          type: "MoneyLineBet",
          amount: 10.0,
          wager: "home",
      }}
    end

    it "creates a MoneyLine bet" do
      expect do
        post "/bets.json", params: @params
        expect(response.status).to eq(201)
      end.to change(Bet, :count).by(1)

      bet = Bet.last!
      expect(bet).to be_a(MoneyLineBet)
      expect(bet.match_id).to eq(@match.id)
      expect(bet.user.id).to eq(@user.id)
      expect(bet.amount).to eq(10.0)
      expect(bet.wager).to eq("home")
    end

    it "fails if the match is closed" do
      @match.update!(:closed => true)
      expect do
        post "/bets.json", params: @params
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)["match"][0]).to eq("Must be open for betting")
      end.to change(Bet, :count).by(0)
    end

    it "fails if there is already a bet on that match for that user" do
      FactoryBot.create(:bet, user_id: @user.id, type: "MoneyLineBet", match: @match, wager: "home")
      expect do
        post "/bets.json", params: @params
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)["match"][0]).to eq("has already been taken")
      end.to change(Bet, :count).by(0)
    end

    it "fails if the user doesn't have enough money in their account" do
      @user.update!(balance: 9)
      expect do
        post "/bets.json", params: @params
        expect(response.status).to eq(422)
      end.to change(Bet, :count).by(0)

      expect(JSON.parse(response.body)["amount"][0]).to eq("must be less than user balance")
    end

    it "accepts a second bet by the same user" do
      FactoryBot.create(:bet, user_id: @user.id, type: "MoneyLineBet", match: @match, wager: "home")

      @params[:bet][:wager] = "away"
      expect do
        post "/bets.json", params: @params
        expect(response.status).to eq(201)
      end.to change(Bet, :count).by(1)

      bet = Bet.last!
      expect(bet.wager).to eq("away")
    end
  end

  describe "generated specs" do

    let(:valid_attributes) {
      {
        user_id: @user.id,
        match_id: @match.id,
        type: "MoneyLineBet",
        amount: 10.0,
        wager: "home",
      }
    }

    let(:invalid_attributes) {
      {
        user_id: @user.id,
        match_id: nil,
        type: "MoneyLineBet",
        amount: 10.0,
        wager: "home",
      }
    }

    describe "GET /index" do
      it "renders a successful response" do
        Bet.create! valid_attributes
        get bets_url
        expect(response).to be_successful
      end
    end

    describe "GET /show" do
      it "renders a successful response" do
        bet = Bet.create! valid_attributes
        get bet_url(bet)
        expect(response).to be_successful
      end
    end

    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new Bet" do
          expect {
            post bets_url, params: { bet: valid_attributes }
          }.to change(Bet, :count).by(1)
        end

        it "redirects to the tournament page" do
          post bets_url, params: { bet: valid_attributes }
          url = tournament_url(@match.tournament)
          expect(response).to redirect_to(url)
        end
      end

      context "with invalid parameters" do
        it "does not create a new Bet" do
          expect {
            post bets_url, params: { bet: invalid_attributes }
          }.to change(Bet, :count).by(0)
        end
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested bet" do
        bet = Bet.create! valid_attributes
        expect {
          delete bet_url(bet)
        }.to change(Bet, :count).by(-1)
      end

      it "redirects to the bets list" do
        bet = Bet.create! valid_attributes
        delete bet_url(bet)
        expect(response).to redirect_to(tournament_url(@match.tournament))
      end
    end
  end
end
