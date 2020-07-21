class Match < ApplicationRecord
  belongs_to :tournament
  belongs_to :home_wrestler, class_name: "Wrestler"
  belongs_to :away_wrestler, class_name: "Wrestler"
  has_many :bets

  def home_bets
    bets.where(wager: "home")
  end

  def away_bets
    bets.where(wager: "away")
  end
end
