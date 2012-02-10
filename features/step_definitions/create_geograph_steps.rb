When /^I name the geograph "([^"]*)"$/ do |geograph_name|
    fill_in('Name', :with => geograph_name)
end

When /^I upload a CSV file containing places and measures with specific column names$/ do
    attach_file("Import data", File.dirname(__FILE__) + '/../../../library2.csv')
end

When /^I create it$/ do
    click_button('Create Geo graph')
end

When /^I add an external data provider$/ do
    check('HOLLIS')
end

Then /^I should be redirected to the "([^"]*)" page for the "([^"]*)" geograph$/ do |path, geograph_name|
    if path == 'show'
        page.current_path.should eq geo_graph_path(GeoGraph.find_by_name(geograph_name))
    else
        page.current_path.should eq send('geo_graph_' + path.gsub(' ', '_') + '_path', GeoGraph.find_by_name(geograph_name))
    end
end

Then /^the "([^"]*)" geograph should contain places$/ do |geograph_name|
    GeoGraph.find_by_name(geograph_name).places.count.should be > 0
end

Then /^the "([^"]*)" geograph should contain data for its places$/ do |geograph_name|
    PlaceMeasure.find_by_place_id_and_measure_id(GeoGraph.find_by_name(geograph_name).places.first.id, Measure.find_by_name('Environment').id).value.should be_between(1, 5)
end

