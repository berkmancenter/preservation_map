class AddGeoGraphToMeasure < ActiveRecord::Migration
  def change
    add_column :measures, :geo_graph_id, :integer

  end
end
