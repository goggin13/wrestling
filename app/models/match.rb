class Match < ApplicationRecord
  belongs_to :tournament
  belongs_to :home_wrestler, class_name: "Wrestler"
  belongs_to :away_wrestler, class_name: "Wrestler"
  belongs_to :winner, class_name: "Wrestler", optional: true
  has_many :bets

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

    number_of_winners = bets.where(wager: winning_bet).count
    amount_per_loser = number_of_winners > 0 ? 0 : 100
    amount_in_pot = bets.count * Bet::PER_MATCH
    amount_per_winner = amount_in_pot / number_of_winners.to_f

    bets.inject({}) do |acc, bet|
      acc[bet.user_id] = bet.won? ? amount_per_winner : amount_per_loser

      acc
    end
  end
end
