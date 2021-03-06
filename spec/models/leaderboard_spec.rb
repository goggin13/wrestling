require 'rails_helper'

RSpec.describe "Leaderboard", type: :model do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    @match_one = FactoryBot.create(:match, tournament: @tournament)
    @match_two = FactoryBot.create(:match, tournament: @tournament)
    @match_three = FactoryBot.create(:match, tournament: @tournament)

  end

  describe "results" do
    it "returns a hash of users and scores" do
      FactoryBot.create(:bet, match: @match_one, wager: "home", user: @user)
      FactoryBot.create(:bet, match: @match_one, wager: "away", user: @other_user)
      FactoryBot.create(:bet, match: @match_two, wager: "home", user: @user)
      FactoryBot.create(:bet, match: @match_two, wager: "away", user: @other_user)

      @match_one.update!(winner: @match_one.home_wrestler)
      @match_two.update!(winner: @match_two.home_wrestler)
      expect(Leaderboard.new(@tournament).results).to eq(
        1 => [[@user, Bet::PER_MATCH * 4]],
        2 => [[@other_user, 0]]
      )
    end

    it "returns ties" do
      FactoryBot.create(:bet, match: @match_one, wager: "home", user: @user)
      FactoryBot.create(:bet, match: @match_one, wager: "home", user: @other_user)
      FactoryBot.create(:bet, match: @match_two, wager: "home", user: @user)
      FactoryBot.create(:bet, match: @match_two, wager: "home", user: @other_user)

      @match_one.update!(winner: @match_one.home_wrestler)
      @match_two.update!(winner: @match_two.home_wrestler)
      expect(Leaderboard.new(@tournament).results).to eq(
        1 => [[@other_user, Bet::PER_MATCH * 2], [@user, Bet::PER_MATCH * 2]],
      )
    end

    it "returns results with the tournament bonus if all matches are won" do
      FactoryBot.create(:bet, match: @match_one, wager: "home", user: @user)
      FactoryBot.create(:bet, match: @match_one, wager: "away", user: @other_user)
      FactoryBot.create(:bet, match: @match_two, wager: "home", user: @user)
      FactoryBot.create(:bet, match: @match_two, wager: "away", user: @other_user)
      FactoryBot.create(:bet, match: @match_three, wager: "home", user: @user)
      FactoryBot.create(:bet, match: @match_three, wager: "away", user: @other_user)

      @match_one.update!(winner: @match_one.home_wrestler)
      @match_two.update!(winner: @match_two.home_wrestler)
      @match_three.update!(winner: @match_three.home_wrestler)

      expect(Leaderboard.new(@tournament).results).to eq(
        1 => [[@user, (Bet::PER_MATCH * 6) + Bet::TOURNAMENT_BONUS]],
        2 => [[@other_user, 0]]
      )
    end

    it "spreads the tournament bonus among ties" do
      FactoryBot.create(:bet, match: @match_one, wager: "home", user: @user)
      FactoryBot.create(:bet, match: @match_one, wager: "home", user: @other_user)
      FactoryBot.create(:bet, match: @match_two, wager: "home", user: @user)
      FactoryBot.create(:bet, match: @match_two, wager: "home", user: @other_user)
      FactoryBot.create(:bet, match: @match_three, wager: "home", user: @user)
      FactoryBot.create(:bet, match: @match_three, wager: "home", user: @other_user)

      @match_one.update!(winner: @match_one.home_wrestler)
      @match_two.update!(winner: @match_two.home_wrestler)
      @match_three.update!(winner: @match_three.home_wrestler)

      expect(Leaderboard.new(@tournament).results).to eq(
        1 => [
          [@other_user, (Bet::PER_MATCH * 3) + (Bet::TOURNAMENT_BONUS / 2.0)],
          [@user, (Bet::PER_MATCH * 3) + (Bet::TOURNAMENT_BONUS / 2.0)],
        ]
      )
    end
  end
end
