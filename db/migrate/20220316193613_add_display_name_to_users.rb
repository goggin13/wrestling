class AddDisplayNameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :display_name, :string
    User.all.each do |user|
      user.display_name = user.email.split("@")[0]
      user.save!
    end
  end
end
