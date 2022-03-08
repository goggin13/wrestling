class AddSpreadToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :spread, :double
  end
end
