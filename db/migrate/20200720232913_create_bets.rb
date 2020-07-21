class CreateBets < ActiveRecord::Migration[6.0]
  def change
    create_table :bets do |t|
      t.integer :user_id
      t.integer :match_id
      t.string :wager

      t.timestamps
    end
  end
end
