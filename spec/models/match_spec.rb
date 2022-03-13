require 'rails_helper'

RSpec.describe "Match", type: :model do
  describe "settle_bets_if_scores_present" do
    before do
      @match = FactoryBot.create(:match, home_score: nil, away_score: nil)
    end

    it "calls settle_bets_for_match when a match is updated with home and away score" do
      expect(BetService).to receive(:settle_bets_for_match).with(@match)
      @match.update!(home_score: 1, away_score: 2)
    end

    it "does not call settle_bets_for_match when a match is updated with the same home and away score" do
      @match.update!(home_score: 1, away_score: 2)
      expect(BetService).to_not receive(:settle_bets_for_match).with(@match)
      @match.update!(home_score: 1, away_score: 2)
    end

    it "does not call settle_bets_for_match when a match is updated but the scores don't change" do
      expect(BetService).to_not receive(:settle_bets_for_match).with(@match)
      @match.update!(spread: 11)
    end

    it "does not call settle_bets_for_match if the match update is invalid" do
      expect(BetService).to_not receive(:settle_bets_for_match).with(@match)
      @match.update(home_score: 1, away_score: 1)
    end
  end

  describe "home_score, away_score" do
    it "is valid if both are set" do
      match = Match.new(home_score: 1, away_score: 2)
      match.save
      expect(match.errors[:home_score].length).to eq(0)
    end

    it "is invalid if the match is not closed" do
      match = Match.new(closed: false, home_score: 1, away_score: 2)
      match.save
      expect(match.errors[:home_score][0]).to eq("match is not closed")
      expect(match.errors[:away_score][0]).to eq("match is not closed")
    end

    it "is valid if neither are set" do
      match = Match.new(home_score: nil, away_score: nil)
      match.save
      expect(match.errors[:home_score].length).to eq(0)
    end

    it "is invalid if only home_score is set" do
      match = Match.new(home_score: nil, away_score: 2)
      match.save
      expect(match.errors[:home_score][0]).to eq("home_score and away_score are both required")
      expect(match.errors[:away_score][0]).to eq("home_score and away_score are both required")
    end

    it "is invalid if only away_score is set" do
      match = Match.new(home_score: 2, away_score: nil)
      match.save
      expect(match.errors[:home_score][0]).to eq("home_score and away_score are both required")
      expect(match.errors[:away_score][0]).to eq("home_score and away_score are both required")
    end

    it "is invalid if home_score == away_score" do
      match = Match.new(home_score: 2, away_score: 2)
      match.save
      expect(match.errors[:home_score][0]).to eq("home_score and away_score must be different")
      expect(match.errors[:away_score][0]).to eq("home_score and away_score must be different")
    end
  end
end
