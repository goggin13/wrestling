class Match < ApplicationRecord
  belongs_to :tournament
  belongs_to :home_wrestler, class_name: "Wrestler"
  belongs_to :away_wrestler, class_name: "Wrestler"
  belongs_to :winner, class_name: "Wrestler", optional: true
  has_many :bets, dependent: :destroy

  def home_bets
    bets.where(wager: "home")
  end

  def away_bets
    bets.where(wager: "away")
  end

  def title
    home_wrestler.name + " vs. " + away_wrestler.name
  end

  def open?
    !closed? && !winner_id.present?
  end

  def payouts
    return {} unless winner.present?

    winning_bet = winner_id == home_wrestler_id ? "home" : "away"
    losing_bet = winner_id == home_wrestler_id ? "away" : "home"

    bets.inject({}) do |acc, bet|
      acc[bet.user_id] = bet.won? ? Bet::PER_MATCH : 0

      acc
    end
  end
end
