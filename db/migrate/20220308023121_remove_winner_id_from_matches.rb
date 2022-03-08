class RemoveWinnerIdFromMatches < ActiveRecord::Migration[6.0]
  def change
    remove_column :matches, :winner_id
  end
end
