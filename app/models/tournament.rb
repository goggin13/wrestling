class Tournament < ApplicationRecord
  has_many :matches

  def current_match
    if current_match_id.present?
      Match.find(current_match_id)
    end
  end
end
