class AddHomeScoreToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :home_score, :int
  end
end
