require 'rails_helper'

RSpec.describe "Leaderboard", type: :model do
  before do
    @user = FactoryBot.create(:user, balance: 100)
    @other_user = FactoryBot.create(:user, balance: 150)
    @tournament = FactoryBot.create(:tournament)
    @match = FactoryBot.create(:match, tournament: @tournament)
  end

  describe "results" do
    it "returns a hash users and balances" do
      FactoryBot.create(:bet, match: @match, user: @user, amount: 10, payout: nil)
      FactoryBot.create(:bet, match: @match, user: @other_user, amount: 10, payout: nil)
      results = Leaderboard.new(@tournament).results
      expect(results).to eq([
        {user: @other_user, rank: 1, balance: 160},
        {user: @user, rank: 2, balance: 110}
      ])
    end

    it "includes outstanding bet amounts" do
      FactoryBot.create(:bet, match: @match, user: @user, amount: 10, payout: nil)
      results = Leaderboard.new(@tournament).results
      expect(results[0][:balance]).to eq(110)
    end

    it "doesn't include bets that are finalized" do
      FactoryBot.create(:bet, match: @match, user: @user, amount: 10, payout: 0)
      results = Leaderboard.new(@tournament).results
      expect(results[0][:balance]).to eq(100)
    end

    it "doesn't include users who have not placed bets in this tournament" do
      bet = FactoryBot.create(:bet)
      results = Leaderboard.new(@tournament).results
      expect(results.length).to eq(0)
    end

    it "returns ties" do
      @other_user.update!(balance: 100)
      third_place_user = FactoryBot.create(:user, balance: 40)
      FactoryBot.create(:bet, match: @match, user: @user, amount: 10, payout: 0)
      FactoryBot.create(:bet, match: @match, user: @other_user, amount: 10, payout: 0)
      FactoryBot.create(:bet, match: @match, user: third_place_user, amount: 10, payout: 0)
      results = Leaderboard.new(@tournament).results
      expect(results).to eq([
        {user: @other_user, rank: 1, balance: 100},
        {user: @user, rank: 1, balance: 100},
        {user: third_place_user, rank: 3, balance: 40},
      ])
    end
  end
end
