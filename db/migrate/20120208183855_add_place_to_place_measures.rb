class AddPlaceToPlaceMeasures < ActiveRecord::Migration
  def change
    add_column :place_measures, :place_id, :integer

  end
end
