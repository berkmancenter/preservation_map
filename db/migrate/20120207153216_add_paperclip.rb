class AddPaperclip < ActiveRecord::Migration
    def up
        change_table :geo_graphs do |t|
            t.has_attached_file :import_data
        end
    end

    def down
        drop_attached_file :geo_graphs, :import_data
    end
end
