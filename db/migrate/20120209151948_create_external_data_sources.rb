class CreateExternalDataSources < ActiveRecord::Migration
  def change
    create_table :external_data_sources do |t|
      t.string :name

      t.timestamps
    end
  end
end
