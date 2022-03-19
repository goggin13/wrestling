class AddBetsSettlingLockToTournaments < ActiveRecord::Migration[6.0]
  def change
    add_column :tournaments, :bets_settling, :boolean
  end
end
