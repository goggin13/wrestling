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
end
