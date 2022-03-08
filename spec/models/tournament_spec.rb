require 'rails_helper'

RSpec.describe "Match", type: :model do
  before do
    @tournament = FactoryBot.create(:tournament)
    @match = FactoryBot.create(:match, tournament: @tournament)
  end

  describe "updating current match" do
    it "closes the current match" do
      @tournament.update!(current_match_id: @match.id)
      @match.reload
      expect(@match.closed?).to eq(true)
    end
  end
end
