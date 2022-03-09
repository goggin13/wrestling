require 'rails_helper'

RSpec.describe Bet, type: :model do

  describe "wager" do
    it "is valid if it is home" do
      bet = Bet.new(wager: "home")
      bet.save
      expect(bet.errors[:wager].length).to eq(0)
    end

    it "is valid if it is away" do
      bet = Bet.new(wager: "away")
      bet.save
      expect(bet.errors[:wager].length).to eq(0)
    end

    it "is invalid if it is not home|away" do
      bet = Bet.new(wager: "neither")
      bet.save
      expect(bet.errors[:wager][0]).to eq("is not included in the list")
    end
  end

  describe "match must be open" do
    it "is invalid if the match is closed" do
      @match = FactoryBot.create(:match, closed: true)
      bet = Bet.new(match: @match)
      bet.save
      expect(bet.errors[:match][0]).to eq("Must be open for betting")
    end
  end

  describe "uniqueness" do
    before do
      @user = FactoryBot.create(:user)
      @match = FactoryBot.create(:match)
    end

    it "fails for a user on the same type of bet forthe same wager and same match" do
      FactoryBot.create(:bet, user: @user, match: @match, type: "MoneyLineBet", wager: "home")
      bet = Bet.new(user: @user, match: @match, type: "MoneyLineBet", wager: "home")
      bet.save
      expect(bet.errors[:match][0]).to eq("has already been taken")
    end

    it "is valid for a user who wagers home and away on the same match" do
      FactoryBot.create(:bet, user: @user, match: @match, type: "MoneyLineBet", wager: "home")
      bet = Bet.new(user: @user, match: @match, type: "MoneyLineBet", wager: "away")
      expect(bet.valid?).to eq(true)
    end
  end
end
