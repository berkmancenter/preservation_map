namespace :insite do
    namespace :external_data do
        desc "Retrieve data from external sources and add/update the database"
        task :retrieve => :environment do
            DataMap.with_external_data.each do |data_map|
                data_map.retrieve_external_data!
            end
        end
    end
end
