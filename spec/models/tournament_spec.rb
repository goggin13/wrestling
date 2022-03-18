require 'rails_helper'

RSpec.describe "Match", type: :model do
  before do
    @tournament = FactoryBot.create(:tournament, in_session: true)
    @match = FactoryBot.create(:match, tournament: @tournament)
  end

  describe "updating current match" do
    it "closes the current match" do
      @tournament.update!(current_match_id: @match.id)
      @match.reload
      expect(@match.closed?).to eq(true)
    end
  end

  describe "current" do
    it "returns the current tournament" do
      FactoryBot.create(:tournament, in_session: false)
      expect(Tournament.current.id).to eq(@tournament.id)
    end
  end

  describe "in_session" do
    it "sets all other tournaments in_session to false if set to true" do
      tournament_1 = FactoryBot.create(:tournament, in_session: true)
      tournament_2 = FactoryBot.create(:tournament, in_session: false)
      tournament_2.update!(in_session: true)

      tournament_1.reload
      tournament_2.reload

      expect(tournament_1.in_session).to eq(false)
      expect(tournament_2.in_session).to eq(true)
    end
  end
end
