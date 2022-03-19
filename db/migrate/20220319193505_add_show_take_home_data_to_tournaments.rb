class AddShowTakeHomeDataToTournaments < ActiveRecord::Migration[6.0]
  def change
    add_column :tournaments, :show_take_home_data, :boolean
  end
end
