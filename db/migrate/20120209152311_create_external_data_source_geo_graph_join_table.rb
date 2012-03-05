class CreateExternalDataSourceGeoGraphJoinTable < ActiveRecord::Migration
    def change
        create_table :external_data_sources_geo_graphs, :id => false do |t|
            t.integer :external_data_source_id
            t.integer :geo_graph_id
        end
  end
end
