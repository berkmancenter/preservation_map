class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :api_abbr
      t.integer :data_map_id

      t.timestamps
    end
    add_index :places, :data_map_id
  end
end
