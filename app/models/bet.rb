class Bet < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :user
  belongs_to :match

  validate :match_must_be_open
  validate :user_has_balance

  validates_uniqueness_of :match, scope: [:user, :wager, :type]
  validates :wager, inclusion: { in: ["home", "away", "over", "under"] }
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

  def self.delete_and_refund_user(bet)
    Bet.transaction do
      bet.user.balance += bet.amount
      bet.destroy
      bet.user.save!

      bet
    end
  end

  def self.calculate_payout(wager, payout_ratio)
    if payout_ratio < 0
      (wager * 100.0 / (payout_ratio * -1)).round(2)
    else
      (wager * payout_ratio / 100.0).round(2)
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

  def formatted_payout_ratio
    if payout_ratio > 0
      "+#{payout_ratio}"
    else
      payout_ratio.to_s
    end
  end

  def wrestler
    if wager == "home"
      match.home_wrestler
    else
      match.away_wrestler
    end
  end

  def set_payout!
    if won?
      self.payout = amount + Bet.calculate_payout(amount, payout_ratio)
    elsif money_back?
      self.payout = amount
    else
      self.payout = 0
    end

    self.save!(validate: false)
  end

  def lost?
    complete? && !win? && !moneyback?
  end
end
