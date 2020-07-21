class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.integer :weight
      t.integer :home_wrestler_id
      t.integer :away_wrestler_id
      t.integer :winner_id
      t.references :tournament, null: false, foreign_key: true

      t.timestamps
    end
  end
end
