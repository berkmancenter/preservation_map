class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.string :api_url
      t.integer :data_map_id
      t.integer :external_data_source_id
      t.string :datatype, :default => 'numeric'
      t.boolean :log_scale, :default => false
      t.boolean :reverse_color_theme, :default => false

      t.timestamps
    end
  end
end
