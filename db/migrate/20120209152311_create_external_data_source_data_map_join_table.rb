class CreateExternalDataSourceDataMapJoinTable < ActiveRecord::Migration
    def change
        create_table :external_data_sources_data_maps, :id => false do |t|
            t.integer :external_data_source_id
            t.integer :data_map_id
        end
  end
end
