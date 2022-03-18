class AddInSessionToTournaments < ActiveRecord::Migration[6.0]
  def change
    add_column :tournaments, :in_session, :boolean
  end
end
