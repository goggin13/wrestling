class Bet < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :user
  belongs_to :match

  validate :match_must_be_open
  validates_uniqueness_of :match, scope: [:user, :wager, :type]
  validates :wager, inclusion: { in: ["home", "away"] }

  def match_must_be_open
    if match.present? && match.closed?
      errors.add(:match, "Must be open for betting")
    end
  end

  def formatted_amount
    number_to_currency(amount)
  end

  def wrestler
    if wager == "home"
      match.home_wrestler
    else
      match.away_wrestler
    end
  end
end
