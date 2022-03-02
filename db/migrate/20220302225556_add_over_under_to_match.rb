class AddOverUnderToMatch < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :over_under, :integer
  end
end
