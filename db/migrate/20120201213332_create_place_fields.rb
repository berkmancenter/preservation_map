class CreatePlaceFields < ActiveRecord::Migration
  def change
    create_table :place_fields do |t|
      t.float :value
      t.integer :place_id
      t.integer :field_id
      t.text :metadata

      t.timestamps
    end
  end
end
