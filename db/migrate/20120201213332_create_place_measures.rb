class CreatePlaceMeasures < ActiveRecord::Migration
  def change
    create_table :place_measures do |t|
      t.float :value
      t.integer :place_id
      t.integer :measure_id
      t.text :metadata

      t.timestamps
    end
  end
end
