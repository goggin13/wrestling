class AddAwayScoreToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :away_score, :int
  end
end
