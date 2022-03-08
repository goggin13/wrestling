require 'rails_helper'

RSpec.describe "Links", type: :feature do
  before do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
  end

  describe "header" do
    it "redirects to a login page" do
      visit root_path
      expect(page).to have_content("You need to sign in or sign up")
    end

    it "shows the logged in user" do
      visit root_path
      login(@user)
      expect(page).to have_content(@user.email)
    end

    it "shows the balance for the logged in user" do
      visit root_path
      login(@user)
      expect(page).to have_content(@user.email)
    end
  end
end
