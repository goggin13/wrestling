class Bet < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :user
  belongs_to :match

  validate :match_must_be_open
  validate :user_has_balance

  validates_uniqueness_of :match, scope: [:user, :wager, :type]
  validates :wager, inclusion: { in: ["home", "away"] }
  validates_presence_of :amount
  validates :amount, numericality: { greater_than: 0 }

  def self.save_and_charge_user(bet)
    Bet.transaction do
      return bet unless bet.save

      bet.user.balance -= bet.amount
      bet.user.save!

      raise ActiveRecord::Rollback if bet.user.reload.balance < 0

      bet
    end
  end

  def user_has_balance
    if user.present? && amount.present? && user.balance < amount
      errors.add(:amount, "must be less than user balance")
    end
  end

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
