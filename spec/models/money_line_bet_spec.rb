require 'rails_helper'

RSpec.describe MoneyLineBet, type: :model do
  describe "win_scenario" do
    it "provides a description" do
      home_wrestler = FactoryBot.create(:wrestler, name: "Kyle Dake")
      match = FactoryBot.create(:match, spread: -7, home_wrestler: home_wrestler)
      bet = FactoryBot.create(:bet, match: match, wager: "home")
      expect(bet.win_scenario).to eq("Kyle Dake wins")
    end
  end

  describe "won?" do
    it "is true if the wager home and the home wrestler wins" do
      match = FactoryBot.create(:match, home_score: 15, away_score: 10)
      bet = FactoryBot.build(:bet, :money_line, match: match, wager: "home")
      expect(bet.won?).to eq(true)
    end

    it "is true if the wager is away and the away wrestler wins" do
      match = FactoryBot.create(:match, home_score: 5, away_score: 10)
      bet = FactoryBot.build(:bet, :money_line, match: match, wager: "away")
      expect(bet.won?).to eq(true)
    end

    it "is false if the wager is home and the away wrestler wins" do
      match = FactoryBot.create(:match, home_score: 5, away_score: 10)
      bet = FactoryBot.build(:bet, :money_line, match: match, wager: "home")
      expect(bet.won?).to eq(false)
    end

    it "is false if the wager is away and the home wrestler wins" do
      match = FactoryBot.create(:match, home_score: 15, away_score: 10)
      bet = FactoryBot.build(:bet, :money_line, match: match, wager: "away")
      expect(bet.won?).to eq(false)
    end
  end

  describe "money_back?" do
    it "returns false" do
      bet = FactoryBot.build(:bet, :money_line)
      expect(bet.money_back?).to eq(false)
    end
  end
end
