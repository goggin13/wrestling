class Tournament < ApplicationRecord
  has_many :matches, dependent: :destroy
  before_save :close_current_match

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
end
