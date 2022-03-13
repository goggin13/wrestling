require 'rails_helper'

RSpec.describe OverUnderBet, type: :model do
  describe "win_scenario" do
    it "provides a description for an over bet" do
      match = FactoryBot.create(:match, over_under: 10)
      bet = FactoryBot.create(:bet, :over_under, match: match, wager: "over")
      expect(bet.win_scenario).to eq("the combined score is over 10")
    end

    it "provides a description for an under bet" do
      match = FactoryBot.create(:match, over_under: 10)
      bet = FactoryBot.create(:bet, :over_under, match: match, wager: "under")
      expect(bet.win_scenario).to eq("the combined score is under 10")
    end
  end

  describe "won?" do
    describe "when over is wagered" do
      it "is true if the total is greater than the over" do
        match = FactoryBot.create(:match, :closed, over_under: 10, home_score: 5, away_score: 10)
        bet = FactoryBot.build(:bet, :over_under, match: match, wager: "over")
        expect(bet.won?).to eq(true)
      end

      it "is false if the total equals the over" do
        match = FactoryBot.create(:match, :closed, over_under: 10, home_score: 4, away_score: 6)
        bet = FactoryBot.build(:bet, :over_under, match: match, wager: "over")
        expect(bet.won?).to eq(false)
      end

      it "is false if the total is under the over" do
        match = FactoryBot.create(:match, :closed, over_under: 10, home_score: 4, away_score: 3)
        bet = FactoryBot.build(:bet, :over_under, match: match, wager: "over")
        expect(bet.won?).to eq(false)
      end
    end

    describe "when under is wagered" do
      it "is true if the total is less than the over_under" do
        match = FactoryBot.create(:match, :closed, over_under: 10, home_score: 5, away_score: 4)
        bet = FactoryBot.build(:bet, :over_under, match: match, wager: "under")
        expect(bet.won?).to eq(true)
      end

      it "is false if the total equals the over_under" do
        match = FactoryBot.create(:match, :closed, over_under: 10, home_score: 4, away_score: 6)
        bet = FactoryBot.build(:bet, :over_under, match: match, wager: "under")
        expect(bet.won?).to eq(false)
      end

      it "is false if the total is over the over_under" do
        match = FactoryBot.create(:match, :closed, over_under: 10, home_score: 14, away_score: 3)
        bet = FactoryBot.build(:bet, :over_under, match: match, wager: "under")
        expect(bet.won?).to eq(false)
      end
    end
  end

  describe "money_back?" do
    it "is true if the score equals the over under" do
      match = FactoryBot.create(:match, :closed, over_under: 10, home_score: 7, away_score: 3)
      bet = FactoryBot.build(:bet, :over_under, match: match)
      expect(bet.money_back?).to eq(true)
    end

    it "is false if the score does not equal the over under" do
      match = FactoryBot.create(:match, :closed, over_under: 10, home_score: 5, away_score: 3)
      bet = FactoryBot.build(:bet, :over_under, match: match)
      expect(bet.money_back?).to eq(false)
    end
  end
end
