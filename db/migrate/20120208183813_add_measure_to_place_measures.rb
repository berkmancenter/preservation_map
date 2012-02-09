class AddMeasureToPlaceMeasures < ActiveRecord::Migration
  def change
    add_column :place_measures, :measure_id, :integer

  end
end
