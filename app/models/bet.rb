class Bet < ApplicationRecord
  PER_MATCH = 75
  PER_USER_TOURNAMENT_BONUS = 250
  NUM_BETTORS = 8
  TOURNAMENT_BONUS = PER_USER_TOURNAMENT_BONUS * NUM_BETTORS
  # BUY_IN = PER_MATCH + PER_USER_TOURNAMENT_BONUS
  belongs_to :user
  belongs_to :match
  validates_presence_of :match
  validates_presence_of :user
  validate :match_must_be_open
  validates :user_id, uniqueness: { scope: :match_id }

  def match_must_be_open
    if match.present? && match.closed?
      errors.add(:match, "Must be open for betting")
    end

    if match.present? && match.winner_id.present?
      errors.add(:match, "Match already has a winner")
    end
  end

  def won?
    (wager == "home" && match.winner_id == match.home_wrestler_id) ||
      (wager == "away" && match.winner_id == match.away_wrestler_id)
  end
end
