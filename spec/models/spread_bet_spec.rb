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

  describe "won?" do
    describe "home favored" do
      it "is true if the wager is home and the home wrestler covers" do
        match = FactoryBot.create(:match, :closed, spread: -5, home_score: 16, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match, wager: "home")
        expect(bet.won?).to eq(true)
      end

      it "is false if the wager is home and the home wrestler loses" do
        match = FactoryBot.create(:match, :closed, spread: -5, home_score: 6, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match, wager: "home")
        expect(bet.won?).to eq(false)
      end

      it "is false if the wager is home and the home wrestler wins but does not cover" do
        match = FactoryBot.create(:match, :closed, spread: -5, home_score: 15, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match, wager: "home")
        expect(bet.won?).to eq(false)
      end

      it "is true if the wager is away and the away wrestler wins" do
        match = FactoryBot.create(:match, :closed, spread: -5, home_score: 4, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match, wager: "away")
        expect(bet.won?).to eq(true)
      end

      it "is true if the wager is away and the away wrestler loses but covers" do
        match = FactoryBot.create(:match, :closed, spread: -5, home_score: 12, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match, wager: "away")
        expect(bet.won?).to eq(true)
      end

      it "is false if the wager is away and the away wrestler loses by more than the spread" do
        match = FactoryBot.create(:match, :closed, spread: -5, home_score: 16, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match, wager: "away")
        expect(bet.won?).to eq(false)
      end
    end

    describe "away favored" do
      it "is true if the wager is home and the home wrestler wins" do
        match = FactoryBot.create(:match, :closed, spread: 5, home_score: 15, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match, wager: "home")
        expect(bet.won?).to eq(true)
      end

      it "is true if the wager is home and the home wrestler loses but covers" do
        match = FactoryBot.create(:match, :closed, spread: 5, home_score: 8, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match, wager: "home")
        expect(bet.won?).to eq(true)
      end

      it "is false if the wager is home and the home wrestler loses by more than the spread" do
        match = FactoryBot.create(:match, :closed, spread: 5, home_score: 4, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match, wager: "home")
        expect(bet.won?).to eq(false)
      end

      it "is true if the wager is away and the away wrestler wins by more than the spread" do
        match = FactoryBot.create(:match, :closed, spread: 5, home_score: 4, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match, wager: "away")
        expect(bet.won?).to eq(true)
      end

      it "is false if the wager is away and the away wrestler wins but does not cover" do
        match = FactoryBot.create(:match, :closed, spread: 5, home_score: 8, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match, wager: "away")
        expect(bet.won?).to eq(false)
      end

      it "is false if the wager is away and the away wrestler loses" do
        match = FactoryBot.create(:match, :closed, spread: 5, home_score: 16, away_score: 15)
        bet = FactoryBot.build(:bet, :spread, match: match, wager: "away")
        expect(bet.won?).to eq(false)
      end
    end
  end

  describe "money_back?" do
    describe "home favored" do
      it "is true if favored wrestler wins by exactly the spread" do
        match = FactoryBot.create(:match, :closed, spread: -5, home_score: 15, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match)
        expect(bet.money_back?).to eq(true)
      end

      it "is false if the favored wrestler loses" do
        match = FactoryBot.create(:match, :closed, spread: -5, home_score: 5, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match)
        expect(bet.money_back?).to eq(false)
      end

      it "is false if the favored wrestler covers the spread" do
        match = FactoryBot.create(:match, :closed, spread: -5, home_score: 16, away_score: 10)
        bet = FactoryBot.build(:bet, :spread, match: match)
        expect(bet.money_back?).to eq(false)
      end
    end

    describe "away favored" do
      it "is true if favored wrestler wins by exactly the spread" do
        match = FactoryBot.create(:match, :closed, spread: 5, home_score: 10, away_score: 15)
        bet = FactoryBot.build(:bet, :spread, match: match)
        expect(bet.money_back?).to eq(true)
      end

      it "is false if the favored wrestler loses" do
        match = FactoryBot.create(:match, :closed, spread: 5, home_score: 10, away_score: 5)
        bet = FactoryBot.build(:bet, :spread, match: match)
        expect(bet.money_back?).to eq(false)
      end

      it "is false if the favored wrestler covers the spread" do
        match = FactoryBot.create(:match, :closed, spread: 5, home_score: 10, away_score: 16)
        bet = FactoryBot.build(:bet, :spread, match: match)
        expect(bet.money_back?).to eq(false)
      end
    end
  end
end
