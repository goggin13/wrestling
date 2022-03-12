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
end
