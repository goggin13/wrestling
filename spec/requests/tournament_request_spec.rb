require 'rails_helper'

RSpec.describe "Tournament", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
  end

  describe "bets_landing_page" do
    it "redirects a user to the tournament page" do
      encoded = Base64.encode64(@user.email).chomp
      get "/tournaments/#{@tournament.id}/bet?c=#{encoded}"

      expect(response.status).to eq(302)
      expect(response).to redirect_to(tournament_path(@tournament))
    end

    it "404s if the tournament doesn't exist" do
      encoded = Base64.encode64(@user.email).chomp
      get "/tournaments/9999999/bet?c=#{encoded}"

      expect(response.status).to eq(404)
    end

    it "displays an error if it can't find the user" do
      encoded = Base64.encode64("not-a-user@email.com").chomp
      get "/tournaments/9999999/bet?c=#{encoded}"

      expect(response.status).to eq(404)
    end

    it "displays an error with not base 64 encoded data" do
      get "/tournaments/9999999/bet?c=123454"

      expect(response.status).to eq(404)
    end
  end
end
