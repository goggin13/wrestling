class AddTotalScoreToMatch < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :total_score, :integer
  end
end
