class AddOverUnderToBets < ActiveRecord::Migration[6.0]
  def change
    add_column :bets, :over_under, :string
  end
end
