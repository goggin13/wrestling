class AddSpreadToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :spread, :float
  end
end
