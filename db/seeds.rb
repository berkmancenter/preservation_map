# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

dir_name = Rails.root.to_s + '/lib/external_data_sources/'

Dir.new(dir_name).each do |filename| 
    if File.file?(dir_name + filename)
        class_name = filename.sub(/\.rb$/,'').camelize
        ExternalDataSource.create(:name => class_name.constantize.name, :class_name => class_name)
    end
end
