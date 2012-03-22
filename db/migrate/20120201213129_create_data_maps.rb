class CreateDataMaps < ActiveRecord::Migration
  def up 
    create_table :data_maps do |t|
      t.string :name
      t.integer :user_id
      t.integer :color_field_id
      t.integer :size_field_id
      t.integer :max_spot_size
      t.integer :min_spot_size
      t.integer :num_legend_sizes
      t.integer :num_legend_colors
      t.integer :color_theme_id
      t.integer :num_zoom_levels
      t.integer :default_zoom_level
      t.float :default_latitude
      t.float :default_longitude
      t.has_attached_file :import_data

      t.timestamps
    end
  end

  def down
    drop_attached_file :data_maps, :import_data
    drop_table :data_maps
  end
end
