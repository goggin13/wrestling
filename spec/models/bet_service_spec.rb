require 'rails_helper'

RSpec.describe BetService, type: :model do
  before do
    @match = FactoryBot.create(:match, spread: -4, over_under: 15)
    @user = FactoryBot.create(:user, balance: 90)
  end

  describe ".settle_bets_for_match" do
    it "pays the user out for a win" do
      bet = FactoryBot.create(:bet, :money_line, match: @match, user: @user, amount: 10, wager: "away")
      @match.update_columns(closed: true, home_score: 5, away_score: 10)
      BetService.settle_bets_for_match(@match)
      bet.reload
      expect(bet.payout).to eq(28)
      @user.reload
      expect(@user.balance).to eq(118)
    end

    it "doesn't revalidate the user has funds for the bet" do
      @user.update!(balance: 10)
      bet = FactoryBot.create(:bet, :money_line, match: @match, user: @user, amount: 10, wager: "away")
      @match.update_columns(closed: true, home_score: 5, away_score: 10)
      @user.update!(balance: 0)
      BetService.settle_bets_for_match(@match)
      bet.reload
      expect(bet.payout).to eq(28)
      @user.reload
      expect(@user.balance).to eq(28)
    end

    it "doesn't pay our for a loss" do
      bet = FactoryBot.create(:bet, :money_line, match: @match, user: @user, amount: 10, wager: "home")
      @match.update_columns(closed: true, home_score: 5, away_score: 10)
      BetService.settle_bets_for_match(@match)
      bet.reload
      expect(bet.payout).to eq(0)
      @user.reload
      expect(@user.balance).to eq(90)
    end

    it "refunds for money back" do
      bet = FactoryBot.create(:bet, :over_under, match: @match, user: @user, amount: 10)
      @match.update_columns(closed: true, home_score: 5, away_score: 10)
      BetService.settle_bets_for_match(@match)
      bet.reload
      expect(bet.payout).to eq(10)
      @user.reload
      expect(@user.balance).to eq(100)
    end
  end
end
