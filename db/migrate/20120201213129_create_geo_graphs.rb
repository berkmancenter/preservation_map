class CreateGeoGraphs < ActiveRecord::Migration
  def change
    create_table :geo_graphs do |t|
      t.string :name

      t.timestamps
    end
  end
end
