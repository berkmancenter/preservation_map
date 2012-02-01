class CreatePlaceMeasures < ActiveRecord::Migration
  def change
    create_table :place_measures do |t|
      t.float :value

      t.timestamps
    end
  end
end
