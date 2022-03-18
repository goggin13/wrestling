class Tournament < ApplicationRecord
  has_many :matches, -> { order(weight: :asc) }, dependent: :destroy
  before_save :close_current_match
  after_update :set_tournament_in_sessions

  def current_match
    if current_match_id.present?
      Match.find(current_match_id)
    end
  end

  def complete?
    matches.where("home_score is not null AND away_score is not null").count == matches.count
  end

  def close_current_match
    if current_match_id.present?
      Match.find(current_match_id).update!(closed: true)
    end
  end

  def self.current
    Tournament.where(in_session: true).first!
  end

  def set_tournament_in_sessions
    if self.saved_change_to_in_session? && self.in_session?
      Tournament.where("id != ?", self.id).update(in_session: false)
    end

    true
  end
end
