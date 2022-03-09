class DropBetsTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :bets
  end
end
