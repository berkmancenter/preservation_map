class CreateDataMapExternalDataSourceJoinTable < ActiveRecord::Migration
    def change
        create_table :data_maps_external_data_sources, :id => false do |t|
            t.integer :external_data_source_id
            t.integer :data_map_id
        end
  end
end
