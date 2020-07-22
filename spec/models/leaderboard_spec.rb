require 'rails_helper'

RSpec.describe "Leaderboard", type: :model do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    @match_one = FactoryBot.create(:match, tournament: @tournament)
    @match_two = FactoryBot.create(:match, tournament: @tournament)

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
        1 => [[@user, 400]],
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
        1 => [[@other_user, 200], [@user, 200]],
      )
    end
  end
end
