class CreateMeasures < ActiveRecord::Migration
  def change
    create_table :measures do |t|
      t.string :name
      t.string :api_url
      t.integer :geo_graph_id
      t.integer :external_data_source_id
      t.boolean :yes_no_maybe
      t.boolean :log_scale
      t.boolean :reverse_color_theme

      t.timestamps
    end
  end
end
