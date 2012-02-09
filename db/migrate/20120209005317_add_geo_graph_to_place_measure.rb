class AddGeoGraphToPlaceMeasure < ActiveRecord::Migration
  def change
    add_column :place_measures, :geo_graph_id, :integer

  end
end
