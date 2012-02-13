class AddDataSourceClassName < ActiveRecord::Migration
    def change
        add_column :external_data_sources, :class_name, :string
    end
end
