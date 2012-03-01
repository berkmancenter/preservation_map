class CreateMeasures < ActiveRecord::Migration
  def change
    create_table :measures do |t|
      t.string :name
      t.string :api_url
      t.integer :geo_graph_id
      t.integer :external_data_source_id
      t.string :datatype, :default => 'numeric'
      t.boolean :log_scale, :default => false
      t.boolean :reverse_color_theme, :default => false

      t.timestamps
    end
  end
end
