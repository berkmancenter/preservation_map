class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :api_abbr

      t.timestamps
    end
  end
end
