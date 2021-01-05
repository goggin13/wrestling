class AddCollegeIdToWrestlers < ActiveRecord::Migration[6.0]
  def change
    add_column :wrestlers, :college_id, :integer
  end
end
