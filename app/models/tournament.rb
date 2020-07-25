class Tournament < ApplicationRecord
  has_many :matches

  def current_match
    if current_match_id.present?
      Match.find(current_match_id)
    end
  end

  def complete?
    matches.where("winner_id is not null").count == matches.count
  end
end
