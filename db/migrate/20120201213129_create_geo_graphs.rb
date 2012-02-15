class CreateGeoGraphs < ActiveRecord::Migration
  def up 
    create_table :geo_graphs do |t|
      t.string :name
      t.integer :user_id
      t.integer :color_measure_id
      t.integer :size_measure_id
      t.integer :max_spot_size
      t.integer :min_spot_size
      t.text :color_theme
      t.has_attached_file :import_data

      t.timestamps
    end
  end

  def down
    drop_attached_file :geo_graphs, :import_data
    drop_table :geo_graphs
  end
end
