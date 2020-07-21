require 'rails_helper'

RSpec.describe "Tournament", type: :feature do
  before do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    home_wrestler = FactoryBot.create(:wrestler, name: "Kyle Dake")
    away_wrestler = FactoryBot.create(:wrestler, name: "Frank Chamizo")
    @match = FactoryBot.create(
      :match,
      tournament: @tournament,
      home_wrestler: home_wrestler,
      away_wrestler: away_wrestler,
      winner_id: nil,
    )
  end

  describe "show" do
    before do
      login(@user)
    end

    it "shows the two wrestlers for the match" do
      visit tournament_path(@tournament)
      expect(page).to have_css(".home")
      expect(page).to have_css(".away")

      expect(page).to_not have_css(".home.selected")
      expect(page).to_not have_css(".away.selected")
    end

    it "assigns the open class if the match doesn't have a winner" do
      visit tournament_path(@tournament)
      expect(page).to have_css(".tournament-match-up.open")
    end

    it "assigns the closed class if the match has a winner" do
      @match.update!(winner_id: 1)
      visit tournament_path(@tournament)
      expect(page).to have_css(".tournament-match-up.closed")
    end

    it "highlights the home wrestler if a bet has been made on home" do
      FactoryBot.create(:bet, user: @user, match: @match, wager: "home")

      visit tournament_path(@tournament)
      expect(page).to have_css(".away")

      expect(page).to have_css(".home.selected")
      expect(page).to_not have_css(".away.selected")
    end

    it "highlights the away wrestler if a bet has been made on away" do
      FactoryBot.create(:bet, user: @user, match: @match, wager: "away")
      visit tournament_path(@tournament)
      expect(page).to have_css(".home")

      expect(page).to have_css(".away.selected")
      expect(page).to_not have_css(".home.selected")
    end
  end

  describe "display" do
    it "shows the current match" do
      @tournament.update(current_match_id: @match.id)
      visit tournament_display_path(@tournament)
      expect(page).to have_content("Kyle Dake vs. Frank Chamizo")
    end

    it "shows no current match" do
      visit tournament_display_path(@tournament)
      expect(page).to have_content("#{@tournament.name} is not in session")
    end
  end
end
