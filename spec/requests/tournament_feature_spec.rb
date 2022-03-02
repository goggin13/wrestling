require 'rails_helper'

RSpec.describe "Tournament", type: :feature do
  before do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    @home_wrestler = FactoryBot.create(:wrestler, name: "Kyle Dake")
    @away_wrestler = FactoryBot.create(:wrestler, name: "Frank Chamizo")
    @match = FactoryBot.create(
      :match,
      tournament: @tournament,
      home_wrestler: @home_wrestler,
      away_wrestler: @away_wrestler,
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
      expect(page).to have_content("Kyle Dake")
      expect(page).to have_content("Frank Chamizo")
    end

    it "shows no current match" do
      visit tournament_display_path(@tournament)
      expect(page).to have_content("#{@tournament.name} is not in session")
    end
  end

  describe "administer" do
    before do
      @user.update(email: "goggin13@gmail.com")
      login(@user)
    end

    describe "open and closing matches" do
      it "allows an admin to close an open match" do
        visit tournament_administer_path(@tournament)
        expect(page).to have_button("Close")
        click_button("Close")

        @match.reload
        expect(page).to have_content("#{@match.title} closed for voting")
        expect(@match).to be_closed
      end

      it "allows an admin to open an closed match" do
        @match.update!(closed: true)
        visit tournament_administer_path(@tournament)
        expect(page).to have_button("Open")
        click_button("Open")

        @match.reload
        expect(page).to have_content("#{@match.title} open for voting")
        expect(@match).to_not be_closed
      end

      it "does not have a button to open a match that has winner" do
        @match.update!(closed: true, winner: @home_wrestler)
        visit tournament_administer_path(@tournament)
        expect(page).to_not have_button("Open")
        expect(page).to have_content("Closed")
      end
    end

    describe "setting the winner of a match" do
      it "shows a select box to set the winner as the home wrestler" do
        visit tournament_administer_path(@tournament)
        select("Kyle Dake", from: "match-#{@match.id}-select")
        click_button("Set winner")

        @match.reload
        expect(@match.winner_id).to eq(@home_wrestler.id)
        expect(page).to have_content("#{@match.title} winner set to Kyle Dake")
      end

      it "shows a select box to set the winner as the away wrestler" do
        visit tournament_administer_path(@tournament)
        select("Frank Chamizo", from: "match-#{@match.id}-select")
        click_button("Set winner")

        @match.reload
        expect(@match.winner_id).to eq(@away_wrestler.id)
        expect(page).to have_content("#{@match.title} winner set to Frank Chamizo")
      end

      it "shows a select box to reset the winner to nil" do
        @match.update(winner_id: @home_wrestler.id)
        visit tournament_administer_path(@tournament)
        select("", from: "match-#{@match.id}-select")
        click_button("Set winner")

        @match.reload
        expect(@match.winner_id).to be_nil
        expect(page).to have_content("#{@match.title} winner set to None")
      end

      it "shows a winner form with the current winner selected" do
        @match.update(winner_id: @home_wrestler.id)
        visit tournament_administer_path(@tournament)
        expect(page).to have_select("match-#{@match.id}-select", :selected => "Kyle Dake")
      end

      it "closes a match when setting the winner if it is still open" do
        expect(@match).to_not be_closed
        visit tournament_administer_path(@tournament)
        select("Kyle Dake", from: "match-#{@match.id}-select")
        click_button("Set winner")

        @match.reload
        expect(@match).to be_closed
      end

      it "allows you to set the total_score as well as winner" do
        expect(@match).to_not be_closed
        visit tournament_administer_path(@tournament)
        select("Kyle Dake", from: "match-#{@match.id}-select")
        select(10, from: "match-#{@match.id}-select-winner")

        click_button("Set winner")

        @match.reload
        expect(@match.total_score).to eq(10)
      end
    end

    describe "Setting the current match" do
      before do
        @second_match = FactoryBot.create(:match,
          tournament: @tournament,
          home_wrestler: FactoryBot.create(:wrestler, name: "Roman Bravo Young"),
          away_wrestler: FactoryBot.create(:wrestler, name: "David Taylor"),
        )
      end

      it "has a selector to set the current match" do
        visit tournament_administer_path(@tournament)
        select("Roman Bravo Young vs. David Taylor", from: "tournament[current_match_id]")
        click_button("Set current match")

        @tournament.reload
        expect(@tournament.current_match_id).to eq(@second_match.id)
      end
    end
  end
end
