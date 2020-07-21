require 'rails_helper'

RSpec.describe "Links", type: :feature do
  before do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
  end

  describe "header" do
    it "redirects to a login page" do
      visit root_path
      expect(page).to have_content("Sign up")
    end

    it "shows the logged in user" do
      visit root_path
      login(@user.email, "password")
      expect(page).to have_content("Current user: #{@user.email}")
    end
  end
end
