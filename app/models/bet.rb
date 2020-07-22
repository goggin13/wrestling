class Bet < ApplicationRecord
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
end
