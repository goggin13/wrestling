class CreateWrestlers < ActiveRecord::Migration[6.0]
  def change
    create_table :wrestlers do |t|
      t.string :name
      t.string :college
      t.integer :college_year
      t.text :bio

      t.timestamps
    end
  end
end
