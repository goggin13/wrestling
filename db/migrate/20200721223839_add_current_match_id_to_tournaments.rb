class AddCurrentMatchIdToTournaments < ActiveRecord::Migration[6.0]
  def change
    add_column :tournaments, :current_match_id, :integer
  end
end
