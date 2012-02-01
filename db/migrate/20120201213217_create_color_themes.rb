class CreateColorThemes < ActiveRecord::Migration
  def change
    create_table :color_themes do |t|
      t.string :gradient

      t.timestamps
    end
  end
end
