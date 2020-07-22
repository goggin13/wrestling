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
end
