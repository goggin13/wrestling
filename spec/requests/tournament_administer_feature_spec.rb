require 'rails_helper'

RSpec.describe "Tournament", type: :feature do
  before do
    @user = FactoryBot.create(:user, :admin)
    @tournament = FactoryBot.create(:tournament)
    @home_wrestler = FactoryBot.create(:wrestler, name: "Kyle Dake")
    @away_wrestler = FactoryBot.create(:wrestler, name: "Frank Chamizo")
    @match = FactoryBot.create(
      :match,
      tournament: @tournament,
      home_wrestler: @home_wrestler,
      away_wrestler: @away_wrestler,
    )

    login(@user)
  end

  describe "Setting the current match" do
    before do
      @second_match = FactoryBot.create(:match,
        tournament: @tournament,
        home_wrestler: FactoryBot.create(:wrestler, name: "Roman Bravo Young"),
        away_wrestler: FactoryBot.create(:wrestler, name: "David Taylor"),
      )
    end

    it "has a selector to set and close the current match" do
      visit tournament_administer_path(@tournament)
      select("David Taylor vs. Roman Bravo Young", from: "tournament[current_match_id]")
      click_button("Set current match")

      @tournament.reload
      @second_match.reload
      expect(@tournament.current_match_id).to eq(@second_match.id)
      expect(@second_match.open?).to eq(false)
    end
  end
end
