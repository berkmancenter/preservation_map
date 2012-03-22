When /^I name the datamap "([^"]*)"$/ do |datamap_name|
    fill_in('Name', :with => datamap_name)
end

When /^I upload a CSV file containing places and fields with specific column names$/ do
    attach_file("Import data", File.dirname(__FILE__) + '/../../../library2.csv')
end

When /^I create it$/ do
    click_button('Create DataMap')
end

When /^I add an external data provider$/ do
    check('Hollis')
end

Then /^I should be redirected to the "([^"]*)" page for the "([^"]*)" datamap$/ do |path, datamap_name|
    if path == 'show'
        page.current_path.should eq data_map_path(DataMap.find_by_name(datamap_name))
    else
        page.current_path.should eq send('data_map_' + path.gsub(' ', '_') + '_path', DataMap.find_by_name(datamap_name))
    end
end

Then /^the "([^"]*)" datamap should contain places$/ do |datamap_name|
    DataMap.find_by_name(datamap_name).places.count.should be > 0
end

Then /^the "([^"]*)" datamap should contain data for its places$/ do |datamap_name|
    PlaceField.find_by_place_id_and_field_id(DataMap.find_by_name(datamap_name).places.first.id, Field.find_by_name('Environment').id).value.should be_between(1, 5)
end

