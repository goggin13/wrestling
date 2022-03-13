require 'rails_helper'

RSpec.describe "Match", type: :feature do
  before do
    @user = FactoryBot.create(:user, :admin)
    @match = FactoryBot.create(:match)

    login(@user)
  end

  describe "editing" do
    it "can change an open match to closed" do
      @match.update!(closed: false)
      visit edit_match_path(@match)

      expect(page).to have_field("match_closed", checked: false)
      check("Closed")

      click_button("Update Match")
      expect(page).to have_content("Match was successfully updated.")
      @match.reload
      expect(@match.closed).to eq(true)
    end

    it "can change a closed match to open" do
      @match.update!(closed: true)
      visit edit_match_path(@match)

      expect(page).to have_field("match_closed", checked: true)
      uncheck("Closed")

      click_button("Update Match")
      expect(page).to have_content("Match was successfully updated.")
      @match.reload
      expect(@match.closed).to eq(false)
    end
  end
end
