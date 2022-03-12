require 'rails_helper'

RSpec.describe SpreadBet, type: :model do
  describe "win_scenario" do
    it "provides a description for a favored home wrestler" do
      home_wrestler = FactoryBot.create(:wrestler, name: "Kyle Dake")
      match = FactoryBot.create(:match, spread: -7, home_wrestler: home_wrestler)
      bet = FactoryBot.create(:bet, :spread, match: match, wager: "home")
      expect(bet.win_scenario).to eq("Kyle Dake wins by more than 7.0 points")
    end

    it "provides a description for an underdog home wrestler" do
      home_wrestler = FactoryBot.create(:wrestler, name: "Kyle Dake")
      match = FactoryBot.create(:match, spread: 7, home_wrestler: home_wrestler)
      bet = FactoryBot.create(:bet, :spread, match: match, wager: "home")
      expect(bet.win_scenario).to eq("Kyle Dake wins, or loses by less than 7.0 points")
    end

    it "provides a description for a favored away wrestler" do
      away_wrestler = FactoryBot.create(:wrestler, name: "Kyle Dake")
      match = FactoryBot.create(:match, spread: 7, away_wrestler: away_wrestler)
      bet = FactoryBot.create(:bet, :spread, match: match, wager: "away")
      expect(bet.win_scenario).to eq("Kyle Dake wins by more than 7.0 points")
    end

    it "provides a description for an underdog away wrestler" do
      away_wrestler = FactoryBot.create(:wrestler, name: "Kyle Dake")
      match = FactoryBot.create(:match, spread: -7, away_wrestler: away_wrestler)
      bet = FactoryBot.create(:bet, :spread, match: match, wager: "away")
      expect(bet.win_scenario).to eq("Kyle Dake wins, or loses by less than 7.0 points")
    end
  end

  describe "moneyback_scenario" do
    it "provides a description for a favored home wrestler" do
      home_wrestler = FactoryBot.create(:wrestler, name: "Kyle Dake")
      match = FactoryBot.create(:match, spread: -7, home_wrestler: home_wrestler)
      bet = FactoryBot.create(:bet, :spread, match: match, wager: "home")
      expect(bet.moneyback_scenario).to eq("Kyle Dake wins by 7.0 points")
    end

    it "provides a description for a favored away wrestler" do
      away_wrestler = FactoryBot.create(:wrestler, name: "Kyle Dake")
      match = FactoryBot.create(:match, spread: 7, away_wrestler: away_wrestler)
      bet = FactoryBot.create(:bet, :spread, match: match, wager: "away")
      expect(bet.moneyback_scenario).to eq("Kyle Dake wins by 7.0 points")
    end
  end
end
