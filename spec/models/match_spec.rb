require 'rails_helper'

RSpec.describe "Match", type: :model do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user, email: "goggin13@gmail.com")
    tournament = FactoryBot.create(:tournament)
    @home_wrestler = FactoryBot.create(:wrestler)
    @away_wrestler = FactoryBot.create(:wrestler)
    @match = FactoryBot.create(
      :match,
      tournament: tournament,
      home_wrestler: @home_wrestler,
      away_wrestler: @away_wrestler,
      over_under: 10,
      winner_id: nil,
    )
  end

  describe "payouts" do
    it "returns an empty hash if there is no winner" do
      expect(@match.payouts).to eq({})
    end

    it "returns a payout for each user" do
      FactoryBot.create(:bet, match: @match, wager: "home", user: @user)
      FactoryBot.create(:bet, match: @match, wager: "away", user: @other_user)

      @match.update!(winner: @home_wrestler)
      expect(@match.payouts).to eq(
        @user.id => Bet::PER_MATCH,
        @other_user.id => 0
      )
    end

    it "returns 0 for everyone if no one picks the winner" do
      FactoryBot.create(:bet, match: @match, wager: "away", user: @user)
      FactoryBot.create(:bet, match: @match, wager: "away", user: @other_user)

      @match.update!(winner: @home_wrestler)
      expect(@match.payouts).to eq(
        @user.id => 0,
        @other_user.id => 0,
      )
    end

    it "awards everyone a point if everyone wins" do
      FactoryBot.create(:bet, match: @match, wager: "home", user: @user)
      FactoryBot.create(:bet, match: @match, wager: "home", user: @other_user)

      @match.update!(winner: @home_wrestler)
      expect(@match.payouts).to eq(
        @user.id => Bet::PER_MATCH,
        @other_user.id => Bet::PER_MATCH,
      )
    end

    it "awards points for correct over under on an over bet" do
      FactoryBot.create(:bet, match: @match, wager: "home", user: @user, over_under: Bet::OVER)

      @match.update!(winner: @away_wrestler, total_score: 11)
      expect(@match.payouts).to eq(@user.id => Bet::PER_OVER_UNDER)
    end

    it "awards points for correct over under on an under bet" do
      FactoryBot.create(:bet, match: @match, wager: "home", user: @user, over_under: Bet::UNDER)

      @match.update!(winner: @away_wrestler, total_score: 7)
      expect(@match.payouts).to eq(@user.id => Bet::PER_OVER_UNDER)
    end

    it "awards no points for over under = total_points" do
      FactoryBot.create(:bet, match: @match, wager: "home", user: @user, over_under: Bet::OVER)

      @match.update!(winner: @away_wrestler, total_score: 10)
      expect(@match.payouts).to eq(@user.id => 0)
    end

    it "awards points for correct over under added to a win" do
      FactoryBot.create(:bet, match: @match, wager: "home", user: @user, over_under: Bet::UNDER)

      @match.update!(winner: @home_wrestler, total_score: 7)
      expect(@match.payouts).to eq(@user.id => Bet::PER_MATCH + Bet::PER_OVER_UNDER)
    end
  end
end
