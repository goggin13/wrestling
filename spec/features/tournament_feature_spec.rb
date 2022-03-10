require 'rails_helper'

RSpec.describe "Tournament", type: :feature do
  before do
    @user = FactoryBot.create(:user, balance: 20)
    @tournament = FactoryBot.create(:tournament)
    @home_wrestler = FactoryBot.create(:wrestler, name: "Kyle Dake")
    @away_wrestler = FactoryBot.create(:wrestler, name: "Frank Chamizo")
    @match = FactoryBot.create(
      :match,
      tournament: @tournament,
      home_wrestler: @home_wrestler,
      away_wrestler: @away_wrestler,
      weight: 125,
    )
  end

  describe "show" do
    before do
      login(@user)
    end

    it "shows the two wrestlers for the match" do
      visit tournament_path(@tournament)
      expect(page).to have_content("125 lbs")
      expect(page).to have_content("Kyle Dake")
      expect(page).to have_content("Frank Chamizo")
    end

    it "places a MoneyLineBet for the away wrestler" do
      visit tournament_path(@tournament)

      fill_in "bet[amount]", with: 10, match: :first
      expect do
        click_button "FC M/L"
      end.to change(Bet, :count).by(1)

      bet = Bet.last
      expect(bet.class).to eq(MoneyLineBet)
      expect(bet.user.id).to eq(@user.id)
      expect(bet.match.id).to eq(@match.id)
      expect(bet.amount).to eq(10)
      expect(bet.wager).to eq("away")

      expect(page).to have_content("Wagered $10.00 FC M/L")
      @user.reload
      expect(@user.balance).to eq(10)
    end

    it "rejects a bet on a closed match" do
      visit tournament_path(@tournament)
      @match.update!(closed: true)

      fill_in "bet[amount]", with: 10, match: :first
      expect do
        click_button "FC M/L"
      end.to change(Bet, :count).by(0)

      expect(page).to have_content("Failed to create bet")
    end

    describe "deleting a bet" do
      it "shows a delete button if a bet exists" do
        bet_id = MoneyLineBet.create!(match: @match, wager: "away", user: @user, amount: 10).id
        visit tournament_path(@tournament)

        expect do
          click_link "Retract $10.00 FC M/L Bet"
        end.to change(Bet, :count).by(-1)

        expect(Bet.where(id: bet_id).count).to eq(0)

        expect(page).to have_content("Removed $10.00 FC M/L Bet")
        @user.reload
        expect(@user.balance).to eq(30)
      end

      it "fails if the match has been closed" do
        bet_id = MoneyLineBet.create!(match: @match, wager: "away", user: @user, amount: 10).id
        visit tournament_path(@tournament)
        @match.update!(closed: true)

        expect do
          click_link "Retract $10.00 FC M/L Bet"
        end.to change(Bet, :count).by(0)

        expect(page).to have_content("Betting on that match has closed")
      end
    end

    it "shows locked bets on a closed match"

    it "displays an error if the user doesn't have enough funds" do
      visit tournament_path(@tournament)

      fill_in "bet[amount]", with: 21, match: :first
      expect do
        click_button "FC M/L"
      end.to change(Bet, :count).by(0)

      expect(page).to have_content("Failed to create bet")
    end

    it "displays a users balance" do
      @user.update!(balance: 100)

      visit tournament_path(@tournament)
      expect(page).to have_content("$100.00")
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
end