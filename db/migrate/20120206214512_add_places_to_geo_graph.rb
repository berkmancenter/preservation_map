class AddPlacesToGeoGraph < ActiveRecord::Migration
  def change
    add_column :places, :geo_graph_id, :integer

  end
end
