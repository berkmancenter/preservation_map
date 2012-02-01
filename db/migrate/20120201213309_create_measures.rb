class CreateMeasures < ActiveRecord::Migration
  def change
    create_table :measures do |t|
      t.string :name
      t.string :api_url

      t.timestamps
    end
  end
end
