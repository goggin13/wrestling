class AddClosedToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :closed, :boolean, default: false
  end
end
