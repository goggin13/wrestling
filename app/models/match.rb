class Match < ApplicationRecord
  belongs_to :tournament
  belongs_to :home_wrestler, class_name: "Wrestler"
  belongs_to :away_wrestler, class_name: "Wrestler"
  has_many :bets, dependent: :destroy

  def home_bets
    bets.where(wager: "home")
  end

  def away_bets
    bets.where(wager: "away")
  end

  def title
    away_wrestler.name + " vs. " + home_wrestler.name
  end

  def open?
    !closed? && !winner_id.present?
  end

  def winner
    return @_winner if defined?(@_winner)
    return unless winner_id.present?

    @_winner = Wrestler.find(winner_id)
  end

  def winner_id
    return nil unless home_score.present? && away_score.present?

    if home_score > away_score
      home_wrestler.id
    else
      away_wrestler.id
    end
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
