class RemoveTotalScoreFromMatches < ActiveRecord::Migration[6.0]
  def change
    remove_column :matches, :total_score
  end
end
