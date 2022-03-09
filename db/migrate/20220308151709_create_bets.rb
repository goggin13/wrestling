class CreateBets < ActiveRecord::Migration[6.0]
  def change
    create_table :bets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true
      t.string :type
      t.float :amount
      t.string :wager
      t.float :payout

      t.timestamps
    end
  end
end
