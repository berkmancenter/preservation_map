class AddUserIdToGeoGraph < ActiveRecord::Migration
  def up
    add_column :geo_graphs, :user_id, :integer
  end

  def down
    remove_column :geo_graphs, :user_id
  end
end
